{% set os = salt['grains.get']('os') %}

update_aptget_db:
  module.run:
    - name: pkg.refresh_db

upgrade_all_aptget_packages:
  module.run:
    - name: pkg.upgrade

{% if os == 'Ubuntu' or os == 'Debian'%}
update_apt_db:
  cmd.run:
    - name: apt update

upgrade_all_apt_packages:
  cmd.run:
    - name: apt -y upgrade
{% endif %}
