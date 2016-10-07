##
## See also:
##  - https://github.com/bechtoldt/salt-modules
##

grafana:
  pkgrepo.managed:
    - name: deb https://packagecloud.io/grafana/stable/debian/ wheezy main
    - key_url: https://packagecloud.io/gpg.key
    - file: /etc/apt/sources.list.d/grafana.list
  pkg.installed:
    - refresh: True
  service.running:
    - name: grafana-server
    - running: True
    - enable: True
    - require:
      - pkg: grafana
