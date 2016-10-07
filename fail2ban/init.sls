# ref: http://hardenubuntu.com/software/install-fail2ban

{% set tld = salt['pillar.get']('fail2ban:tld', 'localhost') %}
{% set contact_email = salt['pillar.get']('fail2ban:contact_email', 'root@' ~ tld) %}

fail2ban:
  pkg.installed: []
  service.running:
    - enable: True
    - reload: True

/etc/fail2ban/jail.local:
  file.managed:
    - source: salt://fail2ban/files/etc/fail2ban.conf.jinja
    - template: jinja
    - context:
        destemail:  {{ contact_email }}
    - watch_in:
      - service: fail2ban

Add fail2ban to local monit_ready_states grain:
  grains.list_present:
    - name: monit_ready_states
    - value: fail2ban
