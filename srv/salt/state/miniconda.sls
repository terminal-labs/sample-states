# File:/srv/salt/miniconda.sls

miniconda_installed:
  cmd.run:
    - name: source ~/miniconda3/etc/profile.d/conda.sh && conda --version

miniconda_installer_present:
  file.managed:
    - name: /home/centos/Miniconda3-latest-Linux-x86_64.sh
    - source: https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
    - skip_verify: True
    - keep_source: True  # Keep to avoid re-downloading.
    - mode: 700
    - onfail:
      - cmd: miniconda_installed

install_miniconda:
  cmd.run:
    - name: 'sudo /home/centos/Miniconda3-latest-Linux-x86_64.sh -b -u'
    - require:
        - miniconda_installer_present
    - onfail:
      - cmd: miniconda_installed

