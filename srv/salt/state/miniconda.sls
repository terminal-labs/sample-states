# File:/srv/salt/miniconda.sls

download_miniconda_installer:
  file.managed:
    - name: /home/centos/Miniconda3-latest-Linux-x86_64.sh
    - source: https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
    - skip_verify: True
    - keep_source: True  # keep to avoid re-downloading.
    - mode: 700

add_miniconda_to_bashrc:  # Add first, so that check in install_miniconda will work if conda is already installed.
  file.replace:
    - name: ~/.bashrc
    - pattern: /^export PATH="/root/miniconda3/bin:$PATH"/
    - repl: export PATH="/root/miniconda3/bin:$PATH"
    - append_if_not_found: True

install_miniconda:
  cmd.run:
#    - name: 'sudo /home/centos/Miniconda3-latest-Linux-x86_64.sh -b -u'
#    - "conda --version || sudo /home/centos/Miniconda3-latest-Linux-x86_64.sh -b -u"
    - name: "echo $(conda --version) && conda --version && echo 'we have conda' || echo 'we did not have conda' && sudo /home/centos/Miniconda3-latest-Linux-x86_64.sh -b -u"

    - unless:
        - cmd.run: echo $(conda --version)

