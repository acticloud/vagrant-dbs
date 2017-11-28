# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/xenial64"
  config.vm.network "forwarded_port", guest: 7474, host: 7474
  config.vm.network "forwarded_port", guest: 7687, host: 7687

  config.vm.provision "shell", inline: <<-SHELL
  for i in /vagrant/provision/??_*.sh; do
    if ! sudo bash "$i"; then
      echo "ERROR: unable to provision phase $i" >&2
      exit 1
    fi
  done
  SHELL

  config.vm.provider "virtualbox" do |v|
    v.memory = 2048
    v.cpus = 2
  end

end
