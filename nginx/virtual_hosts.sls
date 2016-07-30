include:
  - nginx

{%- for slug,obj in salt['pillar.get']('nginx:virtual_hosts', {'localhost':{}}).items() %}

{%-   set name         = obj.get('name', 'localhost') %}
{%-   set author       = obj.get('author', 'root@localhost') %}
{%-   set docroot      = obj.get('docroot', '/var/www/html') %}
{%-   set fcgi_handler = obj.get('fcgi_handler', 'php7_0_params') %}
{%-   set port         = obj.get('port', 80) %}

/etc/nginx/{{ fcgi_handler }}:
  file.exists: []

{{ docroot }}:
  file.directory: []

/etc/nginx/sites-available/{{ slug }}:
  file.managed:
    - source: salt://nginx/files/virtual_host.jinja
    - template: jinja
    - context:
        virtual_host_slug: {{ slug }}
        virtual_host_name: {{ name }}
        virtual_host_author: {{ author }}
        virtual_host_docroot: {{ docroot }}
        virtual_host_fcgi_handler: {{ fcgi_handler }}
        virtual_host_port: {{ port }}

/etc/nginx/vhosts/{{ slug }}:
  file.managed:
    - source: salt://nginx/files/virtual_host_config.jinja
    - template: jinja
    - makedirs: True
    - context:
        virtual_host_slug: {{ slug }}
        virtual_host_name: {{ name }}
        virtual_host_author: {{ author }}
        virtual_host_docroot: {{ docroot }}
        virtual_host_fcgi_handler: {{ fcgi_handler }}
        virtual_host_port: {{ port }}

{%- endfor %}
