get_github_private_key:
  cmd.run:
    - name: export LPASS_DISABLE_PINENTRY=1; cat /rambo/lpass_password | lpass show github-key-private --notes >> /home/{{ grains['deescalated_user'] }}/.ssh/lastpass
    - cwd: /home/{{ grains['deescalated_user'] }}
    - env:
      - HOME: /home/{{ grains['deescalated_user'] }}

get_github_public_key:
  cmd.run:
    - name: export LPASS_DISABLE_PINENTRY=1; cat /rambo/lpass_password | lpass show github-key-public --notes >> /home/{{ grains['deescalated_user'] }}/.ssh/lastpass.pub
    - cwd: /home/{{ grains['deescalated_user'] }}
    - env:
      - HOME: /home/{{ grains['deescalated_user'] }}

set_github_private_key:
  file.managed:
    - name: /home/{{ grains['deescalated_user'] }}/.ssh/lastpass
    - mode: 600
