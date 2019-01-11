default:
	echo "not doing anything fam"

teardown:
	minikube delete

startup:
	minikube start

create_webhook_script:

update_hook:
	kubectl delete configmap bunker-controller
	kubectl create configmap bunker-controller --from-file=config/sync.py

install:
	#kubectl create ns metacontroller
	kubens metacontroller
	kubectl apply -f https://raw.githubusercontent.com/GoogleCloudPlatform/metacontroller/master/manifests/metacontroller-rbac.yaml
	kubectl apply -f https://raw.githubusercontent.com/GoogleCloudPlatform/metacontroller/master/manifests/metacontroller.yaml
	kubectl create namespace bunker
	kubens bunker
	kubectl create -f config/crd.yaml
	kubectl create -f config/controller.yaml
	kubectl create configmap bunker-controller --from-file=config/sync.py
	kubectl create -f config/webhook.yaml

reset: teardown startup
