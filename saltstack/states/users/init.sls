saltmaster:
  user.present:
    - home: /home/saltmaster
    - fullname: saltmaster
    - shell: /bin/bash

sudoer-amazing:
  file.append:
    - name: /etc/sudoers
    - text:
      - "saltmaster    ALL=(ALL)	NOPASSWD: ALL"
