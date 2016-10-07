include:
  - salt

extend:
  Salt Minion Service:
    service.disabled:
      - name: salt-minion

Stop Salt Minion Service:
  service.dead:
    - name: salt-minion

/etc/salt/minion.d/standalone.conf:
  file.managed:
    - source: salt://salt/files/etc/salt/minion.d/standalone.conf.jinja
    - template: jinja

/etc/init/salt-minion.override:
  file.managed:
    - contents: manual

disabled_services:
  grains.present:
    - value:
      - salt-minion
