# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
 
  config.vm.define "server1" do |server|
    server.vm.box = "ubuntu/bionic64"
    server.vm.hostname = "server1"
    server.vm.network "private_network", ip: "192.168.56.20"
    #server.vm.network "private_network", ip: "fd12:3456:7890:abcd::14"
    #server.vm.network "forwarded_port", guest: 8080, host: 8080
    server.vm.provision "shell", path: "init.sh"
  end

  # config.vm.define "server2" do |server|
  #   server.vm.box = "ubuntu/bionic64"
  #   server.vm.hostname = "server2"
  #   server.vm.network "private_network", ip: "192.168.50.21"
  # end
 
end
