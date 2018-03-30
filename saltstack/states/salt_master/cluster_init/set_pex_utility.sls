place_pex_utility_app:
  file.managed:
    - name: /home/vagrant/samplepkg.pex
    - source: salt://samplepkg.pex
    - user: {{ grains['deescalated_user'] }}
    - group: {{ grains['deescalated_user'] }}
