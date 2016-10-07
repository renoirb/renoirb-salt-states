{%- set osrelease = salt['grains.get']('lsb_distrib_codename', 'trusty') %}

include:
  - mysql
  - mysql.salt_local_module

db-server:
  pkg.installed:
    - name: mariadb-server
    - require:
      - pkgrepo: mariadb-apt-repo
  file.managed:
    - name: /etc/mysql/conf.d/server-unicode.cnf
    - source: salt://mysql/files/server-unicode.cnf
    - mode: 644
  service.running:
    - name: mysql
    - reload: True
    - enable: True

/etc/mysql/debian.cnf:
  file.exists

salt-dependency:
  pkg.installed:
    - name: python-mysqldb

/etc/mysql/conf.d/lowmem.cnf:
  file.managed:
    - source: salt://mysql/files/lowmem.cnf
    - mode: 644
