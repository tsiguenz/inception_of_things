#!/bin/bash

set -eu

echo "Installing k3s..."

SERVER_IP="192.168.56.110"
FLAGS="--node-ip $SERVER_IP"
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC=$FLAGS sh -
chmod 644 /etc/rancher/k3s/k3s.yaml

echo "Installing helm3..."

# Yes I'm an acrobat (https://helm.sh/docs/intro/install/#from-script)
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | sh

echo "Deploying apps..."

# sudo kubectl apply -f deployment.yaml
# sudo kubectl apply -f service.yaml
# sudo kubectl apply -f ingress.yaml
