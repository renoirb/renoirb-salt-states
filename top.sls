base:
  '*':
    - basesystem
    - sysdig
    - ubuntu
    - salt
    - ntp
    - mysql
    - php.ng.cli
    - php.ng.memcache
    - php.ng.mysql
    - php.ng.apcu
    - php.ng.fpm
    - nginx.fpm

  '* and not G@level:production':
    - match: compound
    - emailblackhole

  'G@biosversion:VirtualBox and not G@level:production':
    - match: compound
    - mysql.server
    - memcached
    - vagrant
