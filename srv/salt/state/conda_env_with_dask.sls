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
    - name: 'source ~/miniconda3/etc/profile.d/conda.sh && conda activate py39_dask'
    - shell: /bin/bash
    - env:
      - PATH: /root/miniconda3/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/root/bin

check_dask_install_in_ev_py39_dask:
  cmd.run:
    - name: 'source ~/miniconda3/etc/profile.d/conda.sh && conda activate py39_dask && conda list | grep "dask"'

install_dask_in_conda_py39_dask_env:
  cmd.run:
    - name: 'source ~/miniconda3/etc/profile.d/conda.sh && conda activate py39_dask && conda install dask'
    - onfail:
	  - cmd: check_dask_install_in_ev_py39_dask
