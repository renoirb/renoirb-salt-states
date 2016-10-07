{%- set port = salt['pillar.get']('prometheus:exporters:apache_exporter:port', 9117) %}
{%- set listen = salt['grains.get']('internal_ip4', ['0.0.0.0'])[0] %}

include:
  - prometheus.user

{%- from "prometheus/exporter/_macros.sls" import prometheus_exporter -%}

{%- set command_template = '/usr/bin/apache_exporter -telemetry.address "%s:%s"' %}
{%- set command = command_template|format(listen, port) %}

{{ prometheus_exporter('apache', command, port) }}
