
{%- macro prometheus_exporter(slug, command, port, uid='prometheus', gid='prometheus') %}
Setup Prometheus {{ slug }}-exporter:
  pkg.installed:
    - name: {{ slug }}-exporter
    - skip_verify: True
    - skip_suggestions: True
  file.managed:
    - name: /etc/init/{{ slug }}-exporter.conf
    - source: salt://prometheus/exporter/files/exporter.init.jinja
    - template: jinja
    - user: {{ uid }}
    - group: {{ gid }}
    - context:
        uid: {{ uid }}
        gid: {{ gid }}
        slug: {{ slug }}
        command: {{ command }}
    - watch_in:
      - service: {{ slug }}-exporter
  service.running:
    - name: {{ slug }}-exporter
    - running: True
    - enable: True
    - require:
      - pkg: {{ slug }}-exporter

prometheus:exporters:{{ slug }}:
  grains.present:
    - force: True
    - value: {{ port }}

{%- endmacro %}
