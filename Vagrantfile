# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/focal64"
  
  # Configuração da máquina node-master
  config.vm.define "node-master" do |node_master|
    node_master.vm.hostname = "node-master"
    node_master.vm.network "private_network", ip: "192.168.56.10"
    node_master.vm.provider "virtualbox" do |vb|
      vb.memory = "2048"
      vb.cpus = 2
    end
    node_master.vm.provision "shell", path: "node-master.sh"
  end
  
  # Configuração das máquinas workers
  (1..2).each do |i|
    config.vm.define "node-#{i}" do |node|
      node.vm.hostname = "node-#{i}"
      node.vm.network "private_network", ip: "192.168.56.#{i+10}"
      node.vm.provider "virtualbox" do |vb|
        vb.memory = "1024"
        vb.cpus = 1
      end
      node.vm.provision "shell", path: "node-worker.sh"
    end
  end
end

