# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure(2) do |config|
  config.vm.provision "shell", path: "postinstall.sh"

  config.vm.define :ubuntu do |ubuntu|
     ubuntu.vm.box = "ubuntu/xenial64"
     ubuntu.vm.network :private_network, ip: '192.168.50.2'
     ubuntu.vm.synced_folder './shared/ubuntu', '/opt/shared/ubuntu', create: true
  end

  config.vm.define :centos do |centos|
     centos.vm.box = "centos/7"
     centos.vm.network :private_network, ip: '192.168.50.3'
     centos.vm.synced_folder './shared/centos', '/opt/shared/centos', create: true, type: "nfs"
     centos.vm.network "private_network", ip: "192.168.1.2"
  end

  config.vm.define :opensuse do |opensuse|
     opensuse.vm.box = "opensuse/openSUSE-42.3-x86_64"
     opensuse.vm.network :private_network, ip: '192.168.50.4'
     opensuse.vm.synced_folder './shared/opensuse', '/opt/shared/opensuse', create: true
  end

  config.vm.provider 'virtualbox' do |v|
    v.customize ['modifyvm', :id, '--memory', 1024 * 4 ]
    v.customize ["modifyvm", :id, "--cpus", 2]
  end

  if ENV['http_proxy'] != nil and ENV['https_proxy'] != nil and ENV['no_proxy'] != nil 
    if not Vagrant.has_plugin?('vagrant-proxyconf')
      system 'vagrant plugin install vagrant-proxyconf'
      raise 'vagrant-proxyconf was installed but it requires to execute again'
    end
    config.proxy.http     = ENV['http_proxy']
    config.proxy.https    = ENV['https_proxy']
    config.proxy.no_proxy = ENV['no_proxy']
  end
end
