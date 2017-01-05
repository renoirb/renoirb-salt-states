include:
  - mysql.salt_local_module

{% for slug,obj in salt['pillar.get']('mysql:databases', {}).items() %}

{%-   set pillar_key = 'mysql:databases:%s'|format(slug) %}

{%- if 'web-dev' in salt['grains.get']('id') %}
{%-   set database_credentials = {
                      'username': 'root',
                      'password': '',
} %}
{%- else %}
{%-   set database_credentials = salt['pillar.get'](pillar_key, none) %}

Asserting database_credentials has a value for "{{ pillar_key }}":
  test.succeed_without_changes:
    - name: 'Value was {{ database_credentials|json }}'

{%- endif %}

{%- if database_credentials %}

{%-   if database_credentials.get('database') %}
{%-     set database_name = database_credentials.get('database') %}
{%-   else %}
{%-     set database_name = slug %}
{%-   endif %}

{%-   if database_credentials.get('username') != 'root' %}
Ensure {{ database_credentials.username }} user exists:
  mysql_user.present:
    - name: {{ database_credentials.username }}
    - host: '%'
    - password: {{ database_credentials.password }}
    - connection_charset: utf8
    - saltenv:
      - LC_ALL: 'en_US.utf8'
{%-   endif %}

{#
 # Or manually
 #
 #     create database foo CHARACTER SET utf8 COLLATE utf8_general_ci;
 #}
Ensure {{ database_name }} database exists:
  mysql_database.present:
    - name: {{ database_name }}
    - character_set: utf8
    - collate: utf8_general_ci

# See later http://codex.wordpress.org/Hardening_WordPress
Ensure {{ database_credentials.get('username') }} user can access {{ database_name }} database:
  mysql_grants.present:
    - grant: ALL PRIVILEGES
    - database: {{ database_name }}.*
    - host: '%'
    - user: {{ database_credentials.get('username') }}
{%- endif %}

{% endfor %}
