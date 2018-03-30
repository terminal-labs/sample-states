create_build_dir_for_pex:
  file.directory:
    - name:  /home/saltmaster/pex_build
    - user:  saltmaster
    - group: saltmaster

install_venv_for_pex:
  cmd.run:
    - name: virtualenv -p python3 /home/saltmaster/pex_venv 
    - runas: saltmaster

update_pip_for_pex:
  cmd.run:
    - name: ./bin/pip install -U setuptools; ./bin/pip install -U pip
    - cwd: /home/saltmaster/pex_venv
    - runas: saltmaster
