Create prometheus user:
  user.present:
    - name: prometheus
    - fullname: Prometheus runner
    - shell: /bin/false
    - createhome: False
    - system: True
