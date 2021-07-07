lastpass_login:
  cmd.run:
    - name: export LPASS_DISABLE_PINENTRY=1; echo {{ grains['lpass_password'] }} | lpass login --trust api@terminallabs.com
    - cwd: /home/{{ grains['deescalated_user'] }}
    - require:
      - sls: lastpass
