place_mongodb_apt_list_file:
  file.managed:
    - name: /etc/apt/sources.list.d/mongodb.list
    - source: salt://mongodb/mongodb.list

mongodb_ppa_keys:
  cmd.run:
    - name: apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10
    - cwd: /home/{{ grains['deescalated_user'] }}

update_aptget_for_mongodb:
  cmd.run:
    - name: apt-get update
    - cwd: /home/{{ grains['deescalated_user'] }}

# We are forcing the use of apt-get instead of apt.
install_mongodb:
  cmd.run:
    - name: apt-get install -y mongodb-org=2.6.9 mongodb-org-server=2.6.9 mongodb-org-shell=2.6.9 mongodb-org-mongos=2.6.9 mongodb-org-tools=2.6.9
    - cwd: /home/{{ grains['deescalated_user'] }}

place_mongodb_systemd_service_config_file:
  file.managed:
    - name: /lib/systemd/system/mongod.service
    - source: salt://mongodb/mongod.service

update_systemd_for_mongodb:
  cmd.run:
    - name: systemctl daemon-reload
    - cwd: /home/{{ grains['deescalated_user'] }}

start_mongodb:
  cmd.run:
    - name: systemctl start mongod
    - cwd: /home/{{ grains['deescalated_user'] }}
