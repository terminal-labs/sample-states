{% set current_path = salt['environ.get']('PATH', '/bin:/usr/bin') %}

place_sync_conda_file:
  file.managed:
    - name: /home/anaconda-server/sync_conda.sh
    - source: salt://conda/sync_conda.sh
    - user: anaconda-server
    - group: anaconda-server

run_sync_conda_file:
  cmd.run:
    - name: nohup bash sync_conda.sh &
    - cwd: /home/anaconda-server
    - runas: anaconda-server
    - env:
      - PATH: {{ [current_path, '/home/anaconda-server/repo/bin']|join(':') }}
