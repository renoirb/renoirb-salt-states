{% from 'preferences/macros.jinja' import preferences_vimrc %}

{%- set dependencies = salt['pillar.get']('ubuntu:dependencies', []) %}
{%- set remove_files = [
           '/etc/update-motd.d/10-help-text'
          ,'/etc/update-motd.d/51-cloudguest'
          ,'/etc/update-motd.d/98-cloudguest'
] %}

{{ preferences_vimrc('/home/ubuntu/.vimrc', 'ubuntu', 'ubuntu') }}

{%- for file in remove_files %}
Remove {{ file }} we do not need:
  file.absent:
    - name: {{ file }}
{%- endfor %}

Non needed software:
  pkg.purged:
    - pkgs:
      - landscape-common
      - landscape-client
      - whoopsie
      - apport
      - at
      - avahi-daemon
      - avahi-utils

{%- if dependencies %}
Install dependencies [{{ dependencies|join(', ') }}]:
  pkg.installed:
    - pkgs: {{ dependencies }}
    - aggregate: True
{%- endif %}
