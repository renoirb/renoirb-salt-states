{%- set prometheus_exporter_port = salt['pillar.get']('prometheus:exporters:prometheus_exporter:port', 9090) %}
{%- set node_exporter_port = salt['pillar.get']('prometheus:exporters:node_exporter:port', 9100) %}
{%- set apache_exporter_port = salt['pillar.get']('prometheus:exporters:apache_exporter:port', 9117) %}
{%- set level = salt['grains.get']('level', 'local') %}

{%- set self_internal_ip4 = salt['grains.get']('internal_ip4', ['127.0.0.1'])[0] %}

{%- set mine_internal_ips = salt['mine.get']('*', 'internal_ip_addrs') %}

include:
  - ppa
  - prometheus.user

prometheus:
  pkg.installed:
    - refresh: True
    - skip_verify: True
    - skip_suggestions: True
  service.running:
    - running: True
    - enable: True

prometheus:exporters:prometheus:
  grains.present:
    - force: True
    - value: {{ prometheus_exporter_port }}

{%-  set all_minions = [] %}
{%-  for name,private_ip in mine_internal_ips.items() %}
{%-    set role = salt['slsutils.nodename_to_role'](name) %}
{%-    set row = {'name': name, 'private_ip': private_ip[0], 'role': role} %}
{%-    do all_minions.append(row) %}
{%-  endfor %}

{%- set node_exporter_list = [] %}
{%- for m in all_minions %}
{%-   set row = '%s:%s'|format(m.private_ip, node_exporter_port) %}
{%-   do node_exporter_list.append(row) %}
{%- endfor %}

{%-  set apache_list = salt['slsutils.filter_list'](all_minions, 'role', 'web') %}
{%-  set apache_exporter_list = [] %}
{%-  for m in apache_list %}
{%-   set row = '%s:%s'|format(m.private_ip, apache_exporter_port) %}
{%-   do apache_exporter_list.append(row) %}
{%-  endfor %}

{%- set prometheus_exporter = '%s:%s'|format(self_internal_ip4, prometheus_exporter_port) %}
{%- set prometheus_exporter_list = [prometheus_exporter] %}

{%- set command = '/usr/bin/prometheus \
                              -config.file=/etc/prometheus/prometheus.yml \
                              -log.level info \
                              -storage.local.path=/var/lib/prometheus \
' %}

/etc/init/prometheus.conf:
  file.managed:
    - source: salt://prometheus/exporter/files/exporter.init.jinja
    - template: jinja
    - user: prometheus
    - group: prometheus
    - context:
        uid: prometheus
        gid: prometheus
        command: {{ command }}
    - watch_in:
      - service: prometheus

/var/lib/prometheus:
  file.directory:
    - user: prometheus
    - group: prometheus
    - recurse:
      - user
      - group

/etc/prometheus:
  file.directory:
    - user: prometheus
    - group: prometheus
    - recurse:
      - user
      - group

/etc/prometheus/prometheus.yml:
  file.managed:
    - source: salt://prometheus/files/prometheus.yml.jinja
    - template: jinja
    - user: prometheus
    - group: prometheus
    - context:
        prometheus_exporter_list: {{ prometheus_exporter_list|json }}
        node_exporter_list: {{ node_exporter_list|json }}
        apache_exporter_list: {{ apache_exporter_list|json }}
        level: {{ level }}
    - watch_in:
      - service: prometheus

