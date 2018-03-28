set_hostname:
  cmd.run:
    - name: hostname {{ grains['id'] }}
    - cwd: /home/vagrant
    - runas: root

/etc/hostname:
  file.managed:
    - contents: {{ grains['id'] }}
    - backup: false
