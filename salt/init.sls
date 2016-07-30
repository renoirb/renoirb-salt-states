{#
 # If we ever need to compile pygit, see: http://grokbase.com/t/gg/salt-users/1539f3yakm/authentication-error-when-using-gitfs
 #}
deb http://ppa.launchpad.net/rhansen/pygit2/ubuntu trusty main:
  pkgrepo.managed:
    - keyserver: hkp://keyserver.ubuntu.com:80
    - keyid: ACABB5F5
    - refresh_db: True

pygit2 dependencies:
  pkg.installed:
    - pkgs:
      - python-apt
      - python-pygit2

deb http://repo.saltstack.com/apt/ubuntu/14.04/amd64/2016.3 trusty main:
  pkgrepo.managed:
    - humanname: SaltStack repo
    - gpgcheck: 1
    - key_url: https://repo.saltstack.com/apt/ubuntu/14.04/amd64/2016.3/SALTSTACK-GPG-KEY.pub
    - file: /etc/apt/sources.list.d/saltstack-salt-trusty.list
    - clean_file: True
    - refresh_db: True

Salt dependencies:
  pkg.latest:
    - pkgs:
      - salt-common
      - salt-minion
      - python-timelib
      - python-enum34
      - python-bcrypt
      - python-m2ext
      - python-gnupg
      - python-msgpack
      - python-cffi
      - python-libcloud
      - python-psutil

/etc/salt/minion.d/ignore.conf:
  file.managed:
    - source: salt://salt/files/etc/salt/minion.d/ignore.conf.jinja
    - template: jinja

Salt Minion Service:
  service.running:
    - name: salt-minion
    - reload: True
    - enable: True

include:
  - salt.salt_aliases
