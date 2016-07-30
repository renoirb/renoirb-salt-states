#!/bin/bash

set -e

export HOSTNAME=`hostname`

if [ -f "/etc/lsb-release" ]; then
  source /etc/lsb-release
  if [[ "trusty" != "${DISTRIB_CODENAME}" ]]; then
    echo "Unsupported Debian/Ubuntu distribution. This script is designed to work only on Ubuntu 14.04 LTS."
    exit 1
  fi
else
  echo "This script is designed to work only on Ubuntu 14.04 LTS."
  exit 2
fi

## First time we do not find the file, just do it
if [[ ! -f /root/.bootstrap_do_apt_update ]]; then
  apt-get update &&\
  apt-get -y upgrade &&\
  apt-get -y dist-upgrade &&\
  touch /root/.bootstrap_do_apt_update

  ## What we know we'll need in our states for certain
  ## - timelib: Because we have states that generates timestamps
  ## - pygit2: Because we leverage GitFS with Salt post version 2005
  apt-get install -y git-core python-software-properties

  if [[ ! -f /etc/apt/sources.list.d/ppa-rhansen-pygit2.list ]]; then
    apt-key adv --keyserver keyserver.ubuntu.com --recv ACABB5F5
    echo 'deb http://ppa.launchpad.net/rhansen/pygit2/ubuntu trusty main' > /etc/apt/sources.list.d/ppa-rhansen-pygit2.list
    ## Thanks https://repo.saltstack.com/#ubuntu
    wget -O - https://repo.saltstack.com/apt/ubuntu/14.04/amd64/2016.3/SALTSTACK-GPG-KEY.pub | sudo apt-key add -
    echo 'deb http://repo.saltstack.com/apt/ubuntu/14.04/amd64/2016.3 trusty main' > /etc/apt/sources.list.d/saltstack-salt-trusty.list
    apt-get update
  fi

  apt-get install -y salt-minion python-pygit2 python-timelib

  [[ ! -f "/etc/salt/minion.d/id.conf" ]] && printf "id: ${HOSTNAME}\n" > /etc/salt/minion.d/id.conf
fi

## Then, next bootups, conditionally update system
if find /root/.bootstrap_do_apt_update -mtime +10 | grep . > /dev/null 2>&1
then
  echo 'We will be upgrading packages'
  apt-get update &&\
  apt-get -y upgrade &&\
  apt-get -y dist-upgrade &&\
  touch /root/.bootstrap_do_apt_update
else
  echo 'We will not be upgrading packages today, we did it less than 10 days ago.'
fi


[[ -d /vagrant ]] && salt-call --local state.highstate -l info

echo '... bootstrap done'
