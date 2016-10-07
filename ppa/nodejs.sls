#
# For all `setup_n.x` in https://github.com/nodesource/distributions/tree/master/deb
# Replace for `node_n.x` at the end of https://deb.nodesource.com/
#
# Supported as of 2016-07-28:
#   - 4.x
#   - 5.x
#   - 6.x
#
# Example: setup_6.x would be https://deb.nodesource.com/node_6.x
#
{%- set nodesource_version_slug = salt['pillar.get']('ppa:nodejs:version_slug', 'node_6.x') %}
{%- set osrelease = salt['grains.get']('lsb_distrib_codename', 'trusty') %}

Use nodesource.com Node.js PPA:
  pkgrepo.managed:
    ## Aparently nodesource DEB repo has TLS issues
    - name: deb http://deb.nodesource.com/{{ nodesource_version_slug }} {{ osrelease }} main
    - file: /etc/apt/sources.list.d/nodesource-{{ osrelease }}.list
    - key_url: http://deb.nodesource.com/gpgkey/nodesource.gpg.key
  pkg.latest:
    - refresh: True
    - pkgs:
      - rlwrap
      - nodejs
