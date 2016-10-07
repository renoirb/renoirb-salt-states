base:
  '*':
    - preferences
    - sysdig
    - ubuntu
    - salt
    - ntp

  'G@biosversion:VirtualBox and not G@level:production':
    - match: compound
    - vagrant
