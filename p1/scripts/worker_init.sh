#!/bin/bash

set -eu

TOKEN=$(cat /vagrant/shared/token)
SERVER_IP="192.168.56.110"
WORKER_IP="192.168.56.111"
SERVER_URL="https://$SERVER_IP:6443"
FLAGS="--node-ip $WORKER_IP"

echo "Installing k3s..."

# Setting the K3S_URL configure k3s as an agent instead of a server
curl -sfL https://get.k3s.io | K3S_URL=$SERVER_URL K3S_TOKEN=$TOKEN sh -s - $FLAGS
