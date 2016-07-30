{%- from 'php/ng/map.jinja' import php with context %}
{%- set backend_pools = php.fpm.pools %}

{#
#/vagrant/backend_pools.json:
#  file.managed:
#    - contents: |
#        {{ backend_pools|json }}
#}

include:
  - nginx

{# -- See php/ng/fpm/pools_config.sls -- #}
{%- for pool, config in backend_pools.iteritems() %}

{%-   if config.settings|count == 1 %}
{%-     set fpath = php.lookup.fpm.pools ~ '/' ~ config.get('filename', pool) %}
{%-     for pool_block, values in config.settings.iteritems() %}
{%-       set listen = values.listen %}
/etc/nginx/{{ pool_block }}_params:
{%-       if config.enabled %}
  file.managed:
    - source: salt://nginx/files/fpm_params.jinja
    - template: jinja
    - context:
        backend_sock: {{ listen }}
        see_also_file: {{ fpath }}

{%-       else %}
  file.absent: []

{%-       endif %}
{%-     endfor %}
{%-   else %}
State does not support more than one pool block:
  test.fail_without_changes:
    - name: 'Fix this nginx/fpm.sls state #TODO'
{%-   endif %}

{%- endfor %}

/etc/php/7.0/fpm/pool.d/www.conf:
  file.absent: []
