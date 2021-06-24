# File:/srv/salt/python39.sls

install_python39:
  pkg.installed:
    - pkgs:
      - python39
