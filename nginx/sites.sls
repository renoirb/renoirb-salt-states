include:
  - nginx

{%- for slug,obj in salt['pillar.get']('nginx:sites', {}).items() %}

{%-   set name          = obj.get('name', slug) %}
{%-   set author        = obj.get('author', 'root@localhost') %}
{%-   set docroot       = obj.get('docroot', none) %}
{%-   set port          = obj.get('port', 80) %}
{%-   set listen_append = obj.get('listen_append', '') %}
{%-   set fcgi_handler  = obj.get('fcgi_handler', none) %}
{%-   set include       = obj.get('include', none) %}
{%-   set aliases       = obj.get('aliases', [])|join(' ') %}

{%- if docroot != none %}
Ensure {{ docroot }} exists for {{ name }}:
  file.directory:
    - name: {{ docroot }}
{%- endif %}

/etc/nginx/sites-available/{{ slug }}:
  file.managed:
    - source: salt://nginx/files/conf/site.jinja
    - template: jinja
    - context:
        slug: {{ slug }}
        name: {{ name }}
        aliases: {{ aliases }}
        author: {{ author }}
        docroot: {{ docroot }}
        port: {{ port }}
        listen_append: {{ listen_append }}
        fcgi_handler: {{ fcgi_handler }}
        include: {{ include }}

{%- endfor %}
