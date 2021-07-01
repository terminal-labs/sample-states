# File:/srv/salt/dask_in_python39_with_pip.sls

install_dask_in_python39_with_pip:
  pip.installed:
    - names:
      - dask
    - bin_env: '/usr/bin/pip3.9'
    - require:
      - install_python39  # installs python39 and python39-pip
