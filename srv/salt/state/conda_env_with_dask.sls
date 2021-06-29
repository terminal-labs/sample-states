# File:/srv/salt/conda_env_with_dask.sls

conda_env_py39_dask_exists:
  cmd.run:
    - name: 'source ~/miniconda3/etc/profile.d/conda.sh && conda env list | grep "py39_dask"'
    - require:
      - miniconda_installed  # miniconda.sls; will ensure conda is set up.

create_conda_env_py39_dask:
  cmd.run:
    - name: 'source ~/miniconda3/etc/profile.d/conda.sh && conda create --name py39_dask python=3.9'
    - onfail:
      - cmd: conda_env_py39_dask_exists

activate_conda_env_py39_dask:
  cmd.run:
    - name: 'source ~/miniconda3/etc/profile.d/conda.sh && conda activate py39_dask'

dask_installed_in_env_py39_dask:
  cmd.run:
    - name: 'source ~/miniconda3/etc/profile.d/conda.sh && conda activate py39_dask && conda list | grep "dask"'

install_dask_in_conda_py39_dask_env:
  cmd.run:
    - name: 'source ~/miniconda3/etc/profile.d/conda.sh && conda activate py39_dask && conda install dask'
    - onfail:
      - cmd: dask_installed_in_env_py39_dask
