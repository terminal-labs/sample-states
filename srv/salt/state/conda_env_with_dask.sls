# File:/srv/salt/conda_env_with_dask.sls

check_conda_env_py39_dask:
  cmd.run:
    - name: 'conda env list | grep "py39_dask"'
    - shell: /bin/bash
    - env:
      - PATH: /root/miniconda3/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/root/bin
    - require:
      - check_conda_install

create_conda_env_py39_dask:
  cmd.run:
    - name: 'conda create --name py39_dask python=3.9'
    - shell: /bin/bash
    - env:
      - PATH: /root/miniconda3/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/root/bin
    - onfail:
      - cmd: check_conda_env_py39_dask


activate_conda_env_py39_dask:
  cmd.run:
    - name: 'conda activate py39_dask'
    - shell: /bin/bash
    - env:
      - PATH: /root/miniconda3/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/root/bin


#install_dask_in_conda_py39_dask_env:
#  cmd.run:
#    - name: 'conda install dask'
#    - shell: /bin/bash
#    - env:
#      - PATH: /root/miniconda3/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/root/bin
#    - require:
#        - activate_conda_env_py39_dask
