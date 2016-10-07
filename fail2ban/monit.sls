include:
  - monit

/etc/monit/conf.d/fail2ban:
  file.managed:
    - source: salt://fail2ban/files/monit
    - watch_in:
      - service: monit
