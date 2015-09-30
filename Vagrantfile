# VM d'accueil une Ubuntu

Vagrant.configure("2") do |config|
  config.vm.define 'unitex' do |box|
    # Le necessaire pour Docker est disponible de base en Ubuntu 14.04
    box.vm.box = 'trusty-server-cloudimg-amd64-vagrant-disk1'
    # Canonical fournit des box Vagrant ready
    box.vm.box_url = 'https://cloud-images.ubuntu.com/vagrant/trusty/current/trusty-server-cloudimg-amd64-vagrant-disk1.box'
    box.vm.hostname = 'unitex.fqdn.org'
    box.vm.network 'private_network', ip: '192.168.168.24'
    box.vm.provider :virtualbox do |vb|
      vb.customize ['modifyvm', :id, '--memory', '2048']
      vb.customize ['modifyvm', :id, '--cpus', '2']
    end
    box.vm.provision :puppet do |puppet|
      puppet.manifests_path = 'manifests'
      puppet.manifest_file  = 'init.pp'
    end
    box.vm.provision "docker" do |d|
      d.build_image "/vagrant/unitex", args: "-t unitex"
    end
  end
end
