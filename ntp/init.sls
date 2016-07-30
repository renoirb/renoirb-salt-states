Time Keeping packages:
  pkg.installed:
    - pkgs:
      - ntp
      - ntpdate
      - python-timelib
  file.managed:
    - name: /etc/ntp.conf
    - contents: |
        ## Managed by Salt
        driftfile /var/lib/ntp/ntp.drift
        statistics loopstats peerstats clockstats
        filegen loopstats file loopstats type day enable
        filegen peerstats file peerstats type day enable
        filegen clockstats file clockstats type day enable
        restrict -4 default kod notrap nomodify nopeer noquery
        restrict -6 default kod notrap nomodify nopeer noquery

        ## Local users may interrogate the ntp server more closely.
        restrict 127.0.0.1
        restrict ::1

        server us.pool.ntp.org
        server 0.pool.ntp.org
        server 1.pool.ntp.org
        server 2.pool.ntp.org
        server 0.ubuntu.pool.ntp.org
        server 1.ubuntu.pool.ntp.org
        server 2.ubuntu.pool.ntp.org
        server 3.ubuntu.pool.ntp.org
