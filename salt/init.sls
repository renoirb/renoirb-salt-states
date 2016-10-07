{%- set osrelease = salt['grains.get']('lsb_distrib_codename', 'trusty') %}
{%- set lsb_distrib_release = salt['grains.get']('lsb_distrib_release') %}
{%- set salt_release = salt['pillar.get']('salt:release', '2016.3') %}

{#
 # If we ever need to compile pygit, see: http://grokbase.com/t/gg/salt-users/1539f3yakm/authentication-error-when-using-gitfs
 #}
{%- if osrelease == 'trusty' %}
deb http://ppa.launchpad.net/rhansen/pygit2/ubuntu trusty main:
  pkgrepo.managed:
    - keyserver: hkp://keyserver.ubuntu.com:80
    - keyid: ACABB5F5
    - refresh_db: True
    - file: /etc/apt/sources.list.d/pygit2-{{ osrelease }}.list
{%- endif %}

pygit2 dependencies:
  pkg.installed:
    - pkgs:
      - python-apt
      - python-pygit2

deb http://repo.saltstack.com/apt/ubuntu/{{ lsb_distrib_release }}/amd64/{{ salt_release }} {{ osrelease }} main:
  pkgrepo.managed:
    - humanname: SaltStack repo
    - gpgcheck: 1
    - key_url: https://repo.saltstack.com/apt/ubuntu/14.04/amd64/2016.3/SALTSTACK-GPG-KEY.pub
    - file: /etc/apt/sources.list.d/saltstack-salt-{{ osrelease }}.list
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


{%- for conf in [
                'ignore.conf'
               ,'logging.conf'
               ,'switches.conf'
               ] %}
/etc/salt/minion.d/{{ conf }}:
  file.managed:
    - source: salt://salt/files/etc/salt/minion.d/{{ conf }}.jinja
    - template: jinja
{%- endfor %}

Salt Minion Service:
  service.running:
    - name: salt-minion
    - reload: True
    - enable: True

include:
  - salt.salt_aliases
{%- if 'salt-minion' in salt['grains.get']('disabled_services') %}
  - salt.standalone
{%- endif %}
