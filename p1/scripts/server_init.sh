#!/bin/bash

set -eu

echo "Installing k3s..."

SERVER_IP="192.168.56.110"
FLAGS="--node-ip $SERVER_IP"
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC=$FLAGS sh -

echo "Share the token for the worker..."

mkdir -p /vagrant/shared
cat /var/lib/rancher/k3s/server/token > /vagrant/shared/token

chmod 644 /etc/rancher/k3s/k3s.yaml
