create_lpass_password_file:
  file.managed:
    - contents:
      - {{ grains["lpass_password"] }}
    - name: /rambo/lpass_password
    - show_changes: False

lastpass_login:
  cmd.run:
    - name: export LPASS_DISABLE_PINENTRY=1; cat /rambo/lpass_password | lpass login --trust {{ grains["lpass_username"] }}
    - cwd: /home/{{ grains['deescalated_user'] }}
    - env:
      - HOME: /home/{{ grains['deescalated_user'] }}
