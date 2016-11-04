# Define VM memory usage through environment variables
MEMORY = ENV.fetch("VAGRANT_MEMORY", "1024")
PROVIDER = ENV.fetch("VAGRANT_DEFAULT_PROVIDER", "virtualbox")
RELEASE = ENV.fetch("VAGRANT_UBUNTU_RELEASE", "trusty")
SALT_STABLE_RELEASE = ENV.fetch("VAGRANT_SALT_STABLE_RELEASE", "2016.3")

Vagrant.configure(2) do |config|

  if RELEASE == "xenial"
      ## Either use this one
      config.vm.box = "ubuntu/xenial64"
      config.vm.box_check_update = false
  else
      config.vm.box = "trusty-cloud"
      config.vm.box_url = "https://cloud-images.ubuntu.com/vagrant/trusty/current/trusty-server-cloudimg-amd64-vagrant-disk1.box"
  end

  config.ssh.forward_agent = true

  # ref: https://github.com/mitchellh/vagrant/issues/1673
  config.vm.provision "fix-no-tty", type: "shell" do |s|
      s.privileged = false
      s.inline = "sudo sed -i '/tty/!s/mesg n/tty -s \\&\\& mesg n/' /root/.profile"
  end

  config.vm.network "private_network", type: "dhcp"
  config.vm.network "forwarded_port", guest: 80, host: 8080, protocol: "tcp", id: "http", auto_correct: true
  config.vm.network "forwarded_port", guest: 443, host: 8443, protocol: "tcp", id: "https", auto_correct: true

  if Vagrant.has_plugin?("vagrant-cachier")
    # Configure cached packages to be shared between instances of the same base box.
    # More info on http://fgrehm.viewdocs.io/vagrant-cachier/usage
    config.cache.scope = :box
    config.cache.enable :apt
    if RELEASE == "xenial"
        config.cache.synced_folder_opts = {
             owner: "_apt",
             group: "_apt"
        }
    end
  end

  config.vm.synced_folder ".", "/vagrant"
  config.vm.synced_folder "www", "/var/www", create: true
  config.vm.synced_folder "provision/salt", "/etc/salt", create: true

  config.vm.provider "virtualbox" do |v|
    v.name = config.vm.hostname
    # ref: http://www.virtualbox.org/manual/ch08.html
    v.customize ["modifyvm", :id, "--memory", MEMORY]
    v.customize ["modifyvm", :id, "--description", "Vagrant VM in " + File.dirname(__FILE__) ]
    v.customize ["modifyvm", :id, "--ostype", "Ubuntu_64"]
    v.customize ["modifyvm", :id, "--pae", "on"]
  end

  ## TODO, use this instead of my own script
  #config.vm.provision "run bootstrap.saltstack.com", run: "always", keep_color: true, type: "shell" do |s|
  #    s.inline = "curl -L https://bootstrap.saltstack.com | sudo sh -s -- stable $1"
  #    s.args = SALT_STABLE_RELEASE
  #end

  config.vm.provision "https://renoirb.github.io/renoirb-salt-states/bootstrap/"+RELEASE+".sh", run: "always", keep_color: true, type: "shell" do |s|
      s.args = RELEASE
      s.inline = "curl -s -S -L \"https://renoirb.github.io/renoirb-salt-states/bootstrap/$1.sh\" | bash"
  end

  config.vm.provision "shell", run: "always", inline: <<-SHELL
#!/bin/bash

##
## Standalone Web Development VM
##

    set -e

    if [[ ! -f "/vagrant/pillar.yml" ]]; then
      touch /vagrant/pillar.yml
    fi
    if [[ ! -L "/etc/salt/pillar.yml" ]]; then
      ln -s /vagrant/pillar.yml /etc/salt/pillar.yml
    fi

    service salt-minion stop

    salt-call --local ssh.set_known_host user=root hostname=github.com

    if [[ ! -f "/etc/salt/minion.d/fileserver.conf" ]]; then
      echo 'Making sure we have a /etc/salt/minion.d/fileserver.conf'
      mkdir -p /etc/salt/minion.d/
      curl -s -S -L https://renoirb.github.io/renoirb-salt-states/bootstrap/fileserver.conf -o /etc/salt/minion.d/fileserver.conf
    fi

    SETUP=$(salt-call --local pillar.get vagrant:setup --output=json | python -c 'import sys,json; print \",\".join(json.load(sys.stdin)[\"local\"])')
    echo "We will be also applying described in 'vagrant:setup' pillar: " ${SETUP}
    if [[ ! -z ${SETUP} ]]; then
      salt-call --local state.sls $SETUP
    fi

  SHELL

end
