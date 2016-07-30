/etc/profile.d/C6_salt_aliases.sh:
  file.managed:
    - group: users
    - source: salt://salt/files/etc/salt_aliases
