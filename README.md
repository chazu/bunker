# Bunker 
A K8S app for visualizing your terraform config using the brilliant 28mm/blast-radius

# How it works

Someone creates CRD instance for repo @ specific hash - Sync container builds a container which clones the repo and runs blast-radius on it, pushes that container to internal registry, then creates deployment, service and ingress for it, making it available from ze internet

# Setup

Install harbor - https://github.com/goharbor/harbor

# TODO
Should we create helm chart for installation or kustomize? or use config maps?
Add config to install kaniko
Add make target to install all the things in cluster
Add make target to build sync image
Add relevant information to CRD schema (hash and repo)

# DONE
Summarize how it works
Put all config files in config dir
