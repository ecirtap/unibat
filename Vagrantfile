# -*- mode: ruby -*-
# vi: set ft=ruby :

$script = <<-SCRIPT
if ! command -v puppet ; then
  apt update && apt install -qqy puppet
fi
SCRIPT

Vagrant.configure("2") do |config|
  config.vm.define 'unitex' do |box|
    box.vm.box = 'ubuntu/bionic64'
    box.vm.hostname = 'unitex.fqdn.org'
    box.vm.provider :virtualbox do |vb|
      vb.customize ['guestproperty', 'set', :id, '/VirtualBox/GuestAdd/VBoxService/--timesync-set-threshold', 10000 ]
      vb.customize ['modifyvm', :id, '--memory', '2048']
      vb.customize ['modifyvm', :id, '--cpus', '2']
    end
    box.vm.provision "shell",
      inline: $script
    box.vm.provision :puppet do |puppet|
      puppet.manifests_path = 'manifests'
      puppet.module_path = 'modules'
      puppet.manifest_file  = 'init.pp'
    end
    box.vm.provision "docker" do |d|
    end
  end
end
