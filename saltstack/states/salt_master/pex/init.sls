install_venv_for_pex:
  cmd.run:
    - name: virtualenv -p python3 /home/saltmaster/pex_venv 
    - runas: saltmaster

update_venv_pip_for_pex:
  cmd.run:
    - name: ./bin/pip install -U setuptools; ./bin/pip install -U pip
    - cwd: /home/saltmaster/pex_venv
    - runas: saltmaster

install_pex_into_venv:
  cmd.run:
    - name: ./bin/pip install pex
    - cwd: /home/saltmaster/pex_venv
    - runas: saltmaster
    
install_packages_into_venv:
  cmd.run:
    - name: ./bin/pip install requests click
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

build_wheel_for_pex_project:
  cmd.run:
    - name: /home/saltmaster/pex_venv/bin/pip wheel -w . .
    - cwd: /home/saltmaster/pex_build
    - runas: saltmaster

build_app_for_pex_project:
  cmd.run:
    - name: /home/saltmaster/pex_venv/bin/pex --python=python3 -f /home/saltmaster/pex_build requests click myexample -e samplepkg.main -o samplepkg.pex
    - cwd: /home/saltmaster/pex_build
    - runas: saltmaster
    
move_pex_utility_into_salt_dir:
  cmd.run:
    - name: cp -r samplepkg.pex /home/saltmaster/salt_controlplane/etc/salt/samplepkg.pex
    - cwd: /home/saltmaster/pex_build
    - runas: saltmaster
