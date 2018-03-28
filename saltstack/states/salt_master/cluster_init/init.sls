vagrant:
  user.present:
    - home: /home/vagrant
    - fullname: vagrant
    - shell: /bin/bash

place_information_dir:
  file.directory:
    - name: /etc/inflation

place_cluster_information_file:
  file.managed:
    - name: /etc/inflation/cluster_information
    - source: salt://cluster_init/cluster_information.jinja
    - template: jinja

place_node_information_file:
  file.managed:
    - name: /etc/inflation/node_information
    - source: salt://cluster_init/node_information.jinja
    - template: jinja

