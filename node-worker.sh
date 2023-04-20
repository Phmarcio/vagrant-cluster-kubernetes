#!/bin/bash

# Instala o Kubernetes
sudo apt-get update && sudo apt-get install -y apt-transport-https ca-certificates curl
sudo apt-get install -y docker.io
sudo curl -fsSLo /etc/apt/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
echo "deb [signed-by=/etc/apt/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl

# Desativa o swap
sudo swapoff -a
sudo sed -i '/ swap / s/^/#/' /etc/fstab

# Lê o token e o hash do kubeadm do arquivo
read join_token discovery_hash < /vagrant/kubeadm_join_token.txt

# Adiciona a máquina ao cluster
sudo kubeadm join 192.168.56.10:6443 --token $join_token \
             --discovery-token-ca-cert-hash sha256:$discovery_hash
