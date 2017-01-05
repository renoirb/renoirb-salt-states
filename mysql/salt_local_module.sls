/etc/mysql/debian.cnf:
  file.exists

python-mysqldb:
  pkg:
    - installed
  file.managed:
    - name: /etc/salt/minion.d/mysql.conf
    - contents: 'mysql.default_file: "/etc/mysql/debian.cnf"'
