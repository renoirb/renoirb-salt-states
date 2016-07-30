include:
  - mysql
  - mysql.salt_local_module

salt-dependency:
  pkg.installed:
    - name: python-mysqldb
    - require:
      - pkg: db-server
      - file: /etc/mysql/debian.cnf

db-server:
  pkg.installed:
    - pkgs:
      - mariadb-server-10.1
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

/etc/mysql/conf.d/lowmem.cnf:
  file.managed:
    - source: salt://mysql/files/lowmem.cnf
    - mode: 644

/etc/mysql/debian.cnf:
  file.exists:
    - require:
      - pkg: db-server
