{#
 # NGINX common states
 #
 # See also:
 #   - https://github.com/kevva/states/blob/master/nginx/
 #   - [Difference between NGINX versions](https://gist.github.com/jpetazzo/1152774)
 #   - [Strong SSL security on NGINX](https://raymii.org/s/tutorials/Strong_SSL_Security_On_nginx.html)
 #   - http://nginx.org/en/docs/http/ngx_http_core_module.html#variables
 #   - http://www.cyberciti.biz/faq/custom-nginx-maintenance-page-with-http503/
 #   - [All static files will be served directly?](http://stackoverflow.com/questions/19515132/nginx-cache-static-files#answer-20843725)
 #   - https://www.varnish-cache.org/docs/3.0/tutorial/websockets.html
 #   - http://thruflo.com/post/23226473852/websockets-varnish-nginx
 #}

{%- set process_owner = salt['pillar.get']('nginx:process_owner', 'www-data') %}
{%- set errorStatuses = [(403, 'Forbidden'),(404, 'Not Found'),(405, 'Not Allowed'),(500,'Internal Server Error'),(501,'Bad Gateway'),(502,'Service Unavailable')] -%}

NGINX superseeds Apache:
  pkg.purged:
    - pkgs:
      - apache2.2-bin
      - apache2.2-common

nginx:
  pkg.installed:
    - pkgs:
      - nginx-extras
  service.running:
    - enable: True
    - reload: True

/etc/nginx/sites-enabled/default:
  file.absent:
    - require:
      - pkg: nginx

/var/cache/nginx:
  file.directory:
    - user: www-data
    - group: www-data
    - makedirs: True

nginx-ppa:
  pkgrepo.managed:
    - ppa: nginx/stable
    - require_in:
      - pkg: nginx

{% for conf in ['nginx.conf','common_params','ssl_params'] %}
/etc/nginx/{{ conf }}:
  file.managed:
    - source: salt://nginx/files/{{ conf }}.jinja
    - template: jinja
    - context:
        process_owner: {{ process_owner }}
{% endfor %}

/var/www/errors:
  file.directory:
    - createdirs: True

{%- for code, message in errorStatuses %}
/var/www/errors/{{ code }}.html:
  file.managed:
    - source: salt://nginx/files/error.html.jinja
    - template: jinja
    - context:
        code: {{ code }}
        message: {{ message }}
    - require:
      - file: /var/www/errors
      - file: /etc/nginx/common_params
{% endfor %}
