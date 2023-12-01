#!/bin/bash

set -eu

echo "Installing k3s..."

SERVER_IP="192.168.56.110"
FLAGS="--node-ip $SERVER_IP"
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC=$FLAGS sh -
# chmod 644 /etc/rancher/k3s/k3s.yaml

echo "Deploying apps..."

kubectl apply -f deployment.yaml
kubectl apply -f service.yaml
kubectl apply -f ingress.yaml
