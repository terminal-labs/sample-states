lastpass_logout:
  cmd.run:
    - name: lpass logout -f
    - cwd: /home/{{ grains['deescalated_user'] }}
    - env:
      - HOME: /home/{{ grains['deescalated_user'] }}

remove_lpass_password_file:
  cmd.run:
    - name: rm /rambo/lpass_password
    - cwd: /home/{{ grains['deescalated_user'] }}
