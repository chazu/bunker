from BaseHTTPServer import BaseHTTPRequestHandler, HTTPServer
import json

class Controller(BaseHTTPRequestHandler):
  def sync(self, parent, children):
    # Compute status based on observed state.
    print("children")
    print("--------")
    print(children)
    desired_status = {
      "deployments": len(children["Deployment.apps/v1"])
    }

    # Generate the desired child object(s).
    who = parent.get("spec", {}).get("who", "World")
    if desired_status["deployments"] == 0:
      desired_deployments = [
        {
          "apiVersion": "apps/v1beta2",
          "kind": "Deployment",
          "metadata": {
            "name": parent["metadata"]["name"],
            "labels": {
              "app": parent["metadata"]["name"]
            }
          },
          "spec": {
            "replicas": 1,
            "selector": {
              "matchLabels": { "app": parent["metadata"]["name"] }
            },
            "template": {
              "metadata": {
                "labels": {
                  "app": parent["metadata"]["name"]
                }
              },
              "spec": {
                "containers": [
                  {
                    "name": "blast-radius",
                    "image": "28mm/blast-radius",
                    "ports": [
                      {
                        "containerPort": 5000,
                        "targetPort": 5000
                      }
                    ]
                  }
                ]
              }
            }
          }
        }
      ]
    else:
      desired_deployments = []
  
    return {"status": desired_status, "children": desired_deployments}

  def do_POST(self):
    # Serve the sync() function as a JSON webhook.
    observed = json.loads(self.rfile.read(int(self.headers.getheader("content-length"))))
    desired = self.sync(observed["parent"], observed["children"])

    self.send_response(200)
    self.send_header("Content-type", "application/json")
    self.end_headers()
    self.wfile.write(json.dumps(desired))

HTTPServer(("", 80), Controller).serve_forever()
