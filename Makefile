default:
	echo "not doing anything fam"

teardown:
	minikube delete

startup:
	minikube start

create_webhook_script:

create_hook:
	kubectl create configmap bunker-controller --from-file=config/sync.py

update_hook:
	kubectl delete configmap bunker-controller
	kubectl create configmap bunker-controller --from-file=config/sync.py
	#kubectl delete pod $(k get pod | grep bunker | awk '{print $1}')

install:
	kubectl create ns bunker
	kubens bunker
	kubectl apply -f https://raw.githubusercontent.com/GoogleCloudPlatform/metacontroller/master/manifests/metacontroller-rbac.yaml
	kubectl apply -f https://raw.githubusercontent.com/GoogleCloudPlatform/metacontroller/master/manifests/metacontroller.yaml
	kubectl create -f config/crd.yaml
	kubectl create -f config/controller.yaml
	kubectl create configmap bunker-controller --from-file=config/sync.py
	kubectl create -f config/webhook.yaml

reset: teardown startup
