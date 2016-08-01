base:
  '*':
    - sysdig
    - ubuntu
    - salt
    - ntp
    - mysql

  'G@biosversion:VirtualBox and not G@level:production':
    - match: compound
    - mysql.server
    - memcached
    - vagrant

