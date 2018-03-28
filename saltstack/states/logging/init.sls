{% set current_path = salt['environ.get']('PATH', '/bin:/usr/bin') %}
{% set conda_path = '/home/' + grains['deescalated_user'] + '/miniconda3' %}
{% set conda_bin_path = conda_path + '/bin' %}

create_logging_dir:
  file.directory:
    - name: /home/{{ grains['deescalated_user'] }}/logging
    - user: {{ grains['deescalated_user'] }}

clone_logging_system:
   git.latest:
     - name: git@github.com:terminal-labs/logging-system.git
     - target: /home/{{ grains['deescalated_user'] }}/logging/logging-system
     - identity: /home/{{ grains['deescalated_user'] }}/.ssh/lastpass
     - user: root

repo_permissions_for_logging_system:
  file.directory:
    - name: /home/{{ grains['deescalated_user'] }}/logging/logging-system
    - user: {{ grains['deescalated_user'] }}
    - group: {{ grains['deescalated_user'] }}
    - recurse:
      - user
      - group

install_conda_pip_requirements_for_logging_system:
  cmd.run:
    - name: |
        source activate conda_env
        pip install -r /home/{{ grains['deescalated_user'] }}/logging/logging-system/requirements.txt
    - cwd: /home/{{ grains['deescalated_user'] }}
    - runas: {{ grains['deescalated_user'] }}
    - shell: /bin/bash #needed because the command "source" cannot run with /bin/sh. salt can get confused about which shell it should use
    - env:
      - PATH: {{ [current_path, conda_bin_path]|join(':') }}
