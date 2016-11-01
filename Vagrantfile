# Define VM memory usage through environment variables
MEMORY = ENV.fetch("VAGRANT_MEMORY", "1024")
PROVIDER = ENV.fetch("VAGRANT_DEFAULT_PROVIDER", "virtualbox")

Vagrant.configure(2) do |config|

  config.vm.box = "trusty-cloud"
  config.vm.box_url = "https://cloud-images.ubuntu.com/vagrant/trusty/current/trusty-server-cloudimg-amd64-vagrant-disk1.box"
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
  end

  config.vm.synced_folder ".", "/vagrant"
  config.vm.synced_folder "www", "/var/www", create: true
  config.vm.synced_folder "provision/salt/minion.d", "/etc/salt/minion.d", create: true

  config.vm.provider "virtualbox" do |v|
    v.name = config.vm.hostname
    # ref: http://www.virtualbox.org/manual/ch08.html
    v.customize ["modifyvm", :id, "--memory", MEMORY]
    v.customize ["modifyvm", :id, "--description", "Vagrant VM in " + File.dirname(__FILE__) ]
    v.customize ["modifyvm", :id, "--ostype", "Ubuntu_64"]
    v.customize ["modifyvm", :id, "--pae", "on"]
  end

  config.vm.provision "shell", run: "always", inline: <<-SHELL
#!/bin/bash

##
## Standalone Web Development VM
##

set -e

export INIT_LEVEL="vagrant"
export RUNAS="vagrant"
curl -s -S -L "https://renoirb.github.io/renoirb-salt-states/bootstrap/trusty.sh" | bash
salt-call --local ssh.set_known_host user=root hostname=github.com

## Want to use your own git repo, adjust lines below.
## "workstation" below refers to the hosts's private IP
#salt-call --local ssh.set_known_host user=root hostname=workstation
#salt-call --local hosts.add_host 172.28.128.1 workstation

if [[ ! -f /vagrant/provision/pillar.yml ]]; then
  echo 'Making sure we have a /vagrant/provision/pillar.yml'
  mkdir -p /vagrant/provision
  (cat <<- __END_EMBEDDED_FILE__
## This file won't be commited to source-control.
## Sample #TODO
__END_EMBEDDED_FILE__
) > /vagrant/provision/pillar.yml
## What's between __END_EMBEDDED_FILE__ MUST be at column 0
fi

service salt-minion restart

echo 'Running highstate, this may take a while.'

salt-call --local state.highstate -l info

if [[ -d /srv/www ]]; then
  if [[ -f /usr/bin/salt-call ]]; then
    salt-call --local --log-level=quiet --no-color grains.get ip4_interfaces:eth1 --output=json | python -c 'import sys,json; print json.load(sys.stdin)["local"][0]' > /vagrant/.ip
    IP=`cat /vagrant/.ip`
    echo "All done!"
    echo "Now, you can do the following:"
    echo "  Use the VM with this IP address: ${IP}"
    echo "  Ensure you have the following to your Workstation's /etc/hosts file (or C:/Windows/System32/drivers/etc/hosts)"
    echo '--------------------------------------------------------------------'
    ls -1 /srv/www | sed 's/$/.local/' | sed "s/^/${IP}      /"
    echo '--------------------------------------------------------------------'
  fi
fi

  SHELL
end
