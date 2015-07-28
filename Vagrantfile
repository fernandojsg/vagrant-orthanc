# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

settings = {
  :domain => "orthanc",
  :hostname => "orthanc",
  :box => "ubuntu/trusty64",
  :guest_proj_dir => "/home/vagrant/sharedfolder",
  :memory => "1024",
  :ip => "192.168.33.10",
#  :proxy => {
#    :http => "http://10.201.32.8:8080/",
#    :https => "http://10.201.32.8:8080/",
#    :no_proxy => "localhost,127.0.0.1,10.*"
#  }

}

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.

  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = settings[:box]

  # Hostname
  config.vm.host_name = "#{settings[:hostname]}.#{settings[:domain]}"

  config.vm.provider :virtualbox do |vb|
    # Configurate the virtual machine to use 2GB of RAM
    vb.customize ["modifyvm", :id, "--memory", settings[:memory]]
    #vb.name = settings[:virtualbox_name]
  end  

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  config.vm.network "forwarded_port", guest: 8042, host: 8042
  config.vm.network "forwarded_port", guest: 4242, host: 4242
  
  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  config.vm.network "private_network", ip: settings[:ip]

  # If true, then any SSH connections made will enable agent forwarding.
  # Default value: false
  config.ssh.forward_agent = true

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  #config.vm.synced_folder "sharedfolder", settings[:guest_proj_dir], mount_options: ["dmode=777", "fmode=666"]

  # Enable provisioning with Puppet stand alone.  Puppet manifests
  # are contained in a directory path relative to this Vagrantfile.
  # You will need to create the manifests directory and a manifest in
  # the file default.pp in the manifests_path directory.
  #
  config.vm.provision "puppet" do |puppet|
    puppet.manifests_path = "puppet/manifests"
    puppet.manifest_file  = "default.pp"
    puppet.module_path = "puppet/modules"
    # Additional options "--verbose --debug"

    puppet.options = "--hiera_config /vagrant/puppet/manifests/hiera.yaml --manifestdir /tmp/vagrant-puppet/manifests"

  end
end