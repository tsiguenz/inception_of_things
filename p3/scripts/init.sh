#!/bin/bash

source "$(dirname "$0")"/utils.sh

check_root

print_status "Installing docker..."

apt install gnome-terminal

print_status "Cleanup..."
# Cleanup
apt remove docker-desktop 2> /dev/null
rm -r "$HOME"/.docker/desktop 2> /dev/null
rm /usr/local/bin/com.docker.cli 2> /dev/null
apt purge docker-desktop 2> /dev/null

print_status "Add docker's official GPG key..."
apt update
apt install ca-certificates curl gnupg
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
chmod a+r /etc/apt/keyrings/docker.gpg

print_status "Add the repository to Apt sources..."
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null
apt update
apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

print_status "Test installation..."
if docker run hello-world &> /dev/null; then
    print_status "Docker is correctly installed"
else
    print_error "Docker installation failed"
    exit 1
fi

if [ -z "$SUDO_USER" ]; then
	print_status "Add $SUDO_USER to docker group..."
	adduser "$SUDO_USER" docker
fi

print_status "Installing kubectl..."
curl -LO "https://dl.k8s.io/release/$(curl -Ls https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" 2> /dev/null
chmod +x ./kubectl
mv ./kubectl /usr/bin/kubectl
if kubectl version --client &> /dev/null; then
    print_status "kubectl is correctly installed"
else
    print_error "kubectl installation failed"
    exit 1
fi

print_status "Installing k3d..."
curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash
if k3d --version &> /dev/null; then
    print_status "k3d is correctly installed"
else
    print_error "k3d installation failed"
    exit 1
fi

print_status "Installing argocd..."
curl -sSL -o argocd-linux-amd64 https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64
install -m 555 argocd-linux-amd64 /usr/local/bin/argocd
rm argocd-linux-amd64
print_status "argocd is correctly installed"

print_status "Setting up host to access application..."
if grep "devapp.tsiguenz.local" /etc/hosts > /dev/null 2>&1
then
	print_status "Host is already set!"
else
	echo "127.0.0.1       devapp.tsiguenz.local" >> /etc/hosts
	print_status "Host is now setup!"
fi
