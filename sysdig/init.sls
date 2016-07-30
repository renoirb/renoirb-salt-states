Install sysdig and dependencies:
  cmd.run:
    - name: "wget -O - https://s3.amazonaws.com/download.draios.com/DRAIOS-GPG-KEY.public | sudo apt-key add -"
    - unless: test -f /etc/apt/sources.list.d/draios.list

sysdig:
  file.managed:
    - contents: |
        deb http://download.draios.com/stable/deb stable-$(ARCH)/
    - name: /etc/apt/sources.list.d/draios.list
  pkg.installed:
    - refresh: True
    - pkgs:
      - linux-headers-generic
      - sysdig
