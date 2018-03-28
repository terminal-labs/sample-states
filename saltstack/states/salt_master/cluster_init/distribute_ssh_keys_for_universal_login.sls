distribute_pri_ssh_key_for_universal_login_deescalated_user:
  file.managed:
    - name: /var/tmp/universal_cluster_key
    - source: salt://universal_cluster_key
    - user: vagrant
    - group: vagrant

distribute_pub_ssh_key_for_universal_login_deescalated_user:
  file.managed:
    - name: /var/tmp/universal_cluster_key.pub
    - source: salt://universal_cluster_key.pub
    - user: vagrant
    - group: vagrant

place_ssh_config_file:
  file.managed:
    - name: /home/vagrant/.ssh/config
    - source: salt://cluster_init/ssh_config.jinja
    - template: jinja

/var/tmp/universal_cluster_key:
  file.managed:
    - mode: '0400'
