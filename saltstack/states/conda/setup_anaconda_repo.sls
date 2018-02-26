{% set current_path = salt['environ.get']('PATH', '/bin:/usr/bin') %}

create_anaconda_repo_user:
  cmd.run:
    - name: useradd -m anaconda-server
    - cwd: /home/{{ grains['deescalated_user'] }}

create_anaconda_storage_dir:
  cmd.run:
    - name: mkdir -m 0770 -p /opt/anaconda-server/package-storage
    - cwd: /home/{{ grains['deescalated_user'] }}

set_anaconda_storage_dir_ownership:
  cmd.run:
    - name: chown -R anaconda-server:anaconda-server /opt/anaconda-server
    - cwd: /home/{{ grains['deescalated_user'] }}

append_anaconda_server_to_path_in_bashrc:
  file.append:
    - name: /home/anaconda-server/.bashrc
    - text:
      - export PATH="/home/anaconda-server/repo/bin:$PATH"

download_anaconda_repo_installer:
  cmd.run:
    - name: wget https://s3.amazonaws.com/anaconda-repository/anaconda_repository-2.33.3-0-linux-64.sh -O /home/anaconda-server/anaconda_repository.sh
    - cwd: /home/anaconda-server
    - runas: anaconda-server

install_anaconda_repo_server:
  cmd.run:
    - name: bash anaconda_repository.sh -b
    - cwd: /home/anaconda-server
    - runas: anaconda-server

anaconda_config_init:
  cmd.run:
    - name: anaconda-server-config --init
    - cwd: /home/anaconda-server
    - runas: anaconda-server
    - env:
      - PATH: {{ [current_path, '/home/anaconda-server/repo/bin']|join(':') }}

anaconda_config_storage_root:
  cmd.run:
    - name: anaconda-server-config --set fs_storage_root /opt/anaconda-server/package-storage
    - cwd: /home/anaconda-server
    - runas: anaconda-server
    - env:
      - PATH: {{ [current_path, '/home/anaconda-server/repo/bin']|join(':') }}

anaconda_config_mongodb:
  cmd.run:
    - name: anaconda-server-config --set MONGO_URL mongodb://localhost
    - cwd: /home/anaconda-server
    - runas: anaconda-server
    - env:
      - PATH: {{ [current_path, '/home/anaconda-server/repo/bin']|join(':') }}

anaconda_config_auth:
  cmd.run:
    - name: anaconda-server-create-user --username "superuser" --password "yourpassword" --email "your@email.com" --superuser
    - cwd: /home/anaconda-server
    - runas: anaconda-server
    - env:
      - PATH: {{ [current_path, '/home/anaconda-server/repo/bin']|join(':') }}

anaconda_config_repo_package_db:
  cmd.run:
    - name: anaconda-server-db-setup --execute
    - cwd: /home/anaconda-server
    - runas: anaconda-server
    - env:
      - PATH: {{ [current_path, '/home/anaconda-server/repo/bin']|join(':') }}

place_get_miniconda_installers_file:
  file.managed:
    - name: /home/anaconda-server/get_miniconda_installers.sh
    - source: salt://conda/get_miniconda_installers.sh
    - user: anaconda-server
    - group: anaconda-server

place_get_anaconda_installers_file:
  file.managed:
    - name: /home/anaconda-server/get_anaconda_installers.sh
    - source: salt://conda/get_anaconda_installers.sh
    - user: anaconda-server
    - group: anaconda-server

run_get_miniconda_installers_file:
  cmd.run:
    - name: bash get_miniconda_installers.sh
    - cwd: /home/anaconda-server
    - runas: anaconda-server

run_get_anaconda_installers_file:
  cmd.run:
    - name: bash get_anaconda_installers.sh
    - cwd: /home/anaconda-server
    - runas: anaconda-server

copy_anaconda_installers:
  cmd.run:
    - name: cp -a /tmp/extras /home/anaconda-server/repo/lib/python2.7/site-packages/binstar/static
    - cwd: /home/anaconda-server
    - runas: anaconda-server

# This will also generate the /home/anaconda-server/repo/etc/supervisord.conf file and add a crontab rule to restart supervisor after each reboot.
run_anaconda_repo_server:
  cmd.run:
    - name: anaconda-server-install-supervisord-config.sh
    - cwd: /home/anaconda-server
    - runas: anaconda-server
    - env:
      - PATH: {{ [current_path, '/home/anaconda-server/repo/bin']|join(':') }}
