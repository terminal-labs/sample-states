place_known_hosts_file:
  file.managed:
    - name: /home/vagrant/.ssh/known_hosts
    - source: salt://known_hosts
    - runas: vagrant
