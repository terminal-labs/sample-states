# File:/srv/salt/python38.sls

install_python38:
  pkg.installed:
    - pkgs:
      - python38
      - python38-pip
