place_pex_utility_app:
  file.managed:
    - name: /home/vagrant/samplepkg.pex
    - source: salt://samplepkg.pex
    - user: {{ grains['deescalated_user'] }}
    - group: {{ grains['deescalated_user'] }}

set_pex_utility_app_permissions:
  cmd.run:
    - name: chmod +x samplepkg.pex
    - cwd: /home/{{ grains['deescalated_user'] }}
    - runas: {{ grains['deescalated_user'] }}
