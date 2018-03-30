install_venv_for_pex:
  cmd.run:
    - name: virtualenv -p python3 /home/saltmaster/pex_venv 
    - runas: saltmaster

update_venv_pip_for_pex:
  cmd.run:
    - name: ./bin/pip install -U setuptools; ./bin/pip install -U pip
    - cwd: /home/saltmaster/pex_venv
    - runas: saltmaster

create_build_dir_for_pex:
  file.directory:
    - name:  /home/saltmaster/pex_build
    - user:  saltmaster
    - group: saltmaster
 
place_pex_project:
  cmd.run:
    - name: cp -r /vagrant/pex_utility_package/. /home/saltmaster/pex_build
    - cwd: /home/saltmaster
    - runas: saltmaster
