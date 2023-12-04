#!/bin/bash

set -eu

echo "Installing k3s..."

SERVER_IP="192.168.56.110"
FLAGS="--node-ip $SERVER_IP"
CONFS_PATH="/vagrant/confs"
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC=$FLAGS sh -

echo "Deploying apps..."

kubectl apply -f "$CONFS_PATH"/deployment.yaml
kubectl apply -f "$CONFS_PATH"/service.yaml
kubectl apply -f "$CONFS_PATH"/ingress.yaml

chmod 644 /etc/rancher/k3s/k3s.yaml
