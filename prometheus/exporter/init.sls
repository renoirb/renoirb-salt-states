{%- set port = salt['pillar.get']('prometheus:exporters:node_exporter:port', 9100) %}
{%- set listen = salt['grains.get']('internal_ip4', ['0.0.0.0'])[0] %}

include:
  - prometheus.user

{%- from "prometheus/exporter/_macros.sls" import prometheus_exporter -%}

{%- set command_template = '/usr/bin/node_exporter -web.listen-address "%s:%s" -collectors.enabled="stat,time,uname,conntrack,loadavg,sockstat,vmstat,entropy,filefd,filesystem,textfile,meminfo,netdev,netstat,diskstats,tcpstat,bonding,ipvs,ksmd"' %}
{%- set command = command_template|format(listen, port) %}

{{ prometheus_exporter('node', command, port) }}
