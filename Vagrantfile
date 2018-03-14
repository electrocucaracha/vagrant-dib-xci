# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure(2) do |config|
  config.vm.provision "shell", path: "postinstall.sh"

boxes = {
  :virtualbox => {
    :ubuntu   => { :box => "ubuntu/xenial64", :sync_type => "virtualbox" },
    :centos   => { :box => "centos/7", :sync_type => "nfs" },
    :opensuse => { :box => "opensuse/openSUSE-42.3-x86_64", :sync_type => "virtualbox" },
  },
  :libvirt => {
    :ubuntu   => { :box => "elastic/ubuntu-16.04-x86_64", :sync_type => "nfs" },
    :centos   => { :box => "elastic/centos-7-x86_64", :sync_type => "nfs" },
    :opensuse => { :box => "elastic/opensuse-42.2-x86_64", :sync_type => "nfs" },
  },
}
provider = (ENV['VAGRANT_DEFAULT_PROVIDER'] || :virtualbox).to_sym

  config.vm.define :ubuntu do |ubuntu|
     ubuntu.vm.box = boxes[provider][:ubuntu][:box]
     ubuntu.vm.network :private_network, ip: '192.168.50.2'
     ubuntu.vm.synced_folder './shared/ubuntu', '/opt/shared/ubuntu', create: true, type: boxes[provider][:ubuntu][:sync_type]
  end

  config.vm.define :centos do |centos|
     centos.vm.box = boxes[provider][:centos]
     centos.vm.network :private_network, ip: '192.168.50.3'
     centos.vm.synced_folder './shared/centos', '/opt/shared/centos', create: true, type: boxes[provider][:centos][:sync_type]
  end

  config.vm.define :opensuse do |opensuse|
     opensuse.vm.box = boxes[provider][:opensuse]
     opensuse.vm.network :private_network, ip: '192.168.50.4'
     opensuse.vm.synced_folder './shared/opensuse', '/opt/shared/opensuse', create: true, type: boxes[provider][:opensuse][:sync_type]
  end

  config.vm.provider 'virtualbox' do |v|
    v.customize ['modifyvm', :id, '--memory', 4 * 1024 ]
    v.customize ["modifyvm", :id, "--cpus", 2]
  end

  config.vm.provider 'libvirt' do |l|
    l.memory = 4 * 1024
    l.cpu_mode = 'host-passthrough'
    l.cpus = 2
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
