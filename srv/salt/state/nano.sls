# File: /srv/salt/nano.sls

install_nano:
  pkg.installed:
    - pkgs:
      - nano
