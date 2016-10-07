{#
 # Run some states ONLY IF it is the first time
 #
 # Inspiration: http://ryandlane.com/blog/2014/09/02/saltstack-patterns-grainstate/
 #}
first_run_timestamp:
  grains.present:
    - value: "{{ salt['slsutils.strftime']() }}"
    - force: False
    - order: last
