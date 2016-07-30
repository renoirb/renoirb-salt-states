memcached:
  pkg.installed:
    - pkgs:
      - memcached
      - libmemcached-tools
  service.running:
    - reload: True
    - enable: True
