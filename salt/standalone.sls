/etc/salt/minion.d/standalone.conf:
  file.managed:
    - source: salt://salt/files/etc/salt/minion.d/standalone.conf.jinja
    - template: jinja
