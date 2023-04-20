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

# Configura o node-master como master do cluster
sudo kubeadm init --pod-network-cidr=192.168.56.0/24 --apiserver-advertise-address=192.168.56.10 | tee /vagrant/kubeadm_init.log

# Copia o arquivo de configuração do cluster para o usuário normal
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# Instala o plugin de rede calico network plugin
kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.25.0/manifests/calico.yaml

# Gera um token de acesso para adicionar os workers ao cluster
kubeadm token create --print-join-command --ttl 0 | awk '{print $5 " " $6}' > /vagrant/kubeadm_join_token.txt
