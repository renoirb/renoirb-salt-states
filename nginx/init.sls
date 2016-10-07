{%- set process_owner = salt['pillar.get']('nginx:process_owner', 'www-data') %}
{%- set errorStatuses = [ (403, 'Forbidden')
                         ,(404, 'Not Found')
                         ,(405, 'Not Allowed')
                         ,(500,'Internal Server Error')
                         ,(501,'Bad Gateway')
                         ,(502,'Service Unavailable')
] %}

NGINX superseeds Apache:
  pkg.purged:
    - pkgs:
      - apache2.2-bin
      - apache2.2-common

nginx:
  pkgrepo.managed:
    - ppa: nginx/stable
    - keyid: C300EE8C
    - file: /etc/apt/sources.list.d/nginx-stable.list
  pkg.installed:
    - refresh: True
    - pkgs:
      - nginx
      - nginx-extras
  service.running:
    - enable: True
    - reload: True

/etc/nginx/sites-enabled/default:
  file.absent: []

/var/log/nginx:
  file.directory:
    - user: {{ process_owner }}
    - group: {{ process_owner }}

/usr/local/sbin/nginx-site:
  file.managed:
    - source: salt://nginx/files/nginx-site.sh
    - mode: 754

/var/cache/nginx:
  file.directory:
    - user: {{ process_owner }}
    - group: {{ process_owner }}
    - makedirs: True

{%- for conf in [
                'compression.conf'
               ,'filecache.conf'
               ,'headers.conf'
               ,'logging.conf'
               ,'charset.conf'
               ,'tls.conf'
               ] %}
/etc/nginx/conf.d/{{ conf }}:
  file.managed:
    - source: salt://nginx/files/conf/{{ conf }}
    - user: {{ process_owner }}
    - group: {{ process_owner }}
{%- endfor %}

/etc/nginx/nginx.conf:
  file.managed:
    - source: salt://nginx/files/conf/nginx.conf.jinja
    - template: jinja
    - user: {{ process_owner }}
    - group: {{ process_owner }}
    - context:
        process_owner: {{ process_owner }}

/etc/nginx/fpm_params:
  file.managed:
    - source: salt://nginx/files/conf/fpm_params
    - user: {{ process_owner }}
    - group: {{ process_owner }}

/etc/nginx/common_params:
  file.managed:
    - source: salt://nginx/files/conf/common_params
    - user: {{ process_owner }}
    - group: {{ process_owner }}

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
{%- endfor %}
