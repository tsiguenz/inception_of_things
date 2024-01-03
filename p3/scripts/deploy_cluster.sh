#!/bin/bash

source "$(dirname "$0")"/utils.sh

print_status "Deploy k3d cluster..."

k3d cluster create iot --api-port 6443 -p "80:80@loadbalancer" --agents 1 --wait
mkdir -p ~/.kube
k3d kubeconfig get iot > ~/.kube/config

kubectl create namespace argocd
kubectl create namespace dev

kubectl apply -n argocd \
	-f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

kubectl patch configmap argocd-cmd-params-cm -n argocd \
				-p '{"data": {"server.insecure": "true"}}'

kubectl apply -n argocd -f "$(dirname "$0")"/../confs/argocd_ingress.yml
print_status "Wait for argocd-server to be ready..."
kubectl wait -n argocd --for=condition=available --timeout=600s deployment/argocd-server

print_status "Connecting to argocd api..."
ARGOCD_USERNAME="admin"
ARGOCD_PASSWORD=$(kubectl -n argocd get secret argocd-initial-admin-secret \
													-o jsonpath="{.data.password}" | base64 -d)
ARGOCD_API_ADDRESS="localhost:80"

print_status "Password is $ARGOCD_PASSWORD"
argocd login "$ARGOCD_API_ADDRESS"	--insecure --plaintext --grpc-web \
																		--username "$ARGOCD_USERNAME" \
																		--password "$ARGOCD_PASSWORD"

print_status "Creating app dev..."
argocd app create dev --repo "https://github.com/tsiguenz/tsiguenz-iot-app-repo.git" \
											--path "dev" \
											--dest-namespace "dev" \
											--dest-server "https://kubernetes.default.svc" \
											--grpc-web \
											--sync-policy automated \
											--auto-prune \
											--self-heal

