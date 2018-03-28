base:
  'roles:master':
    - match: grain
    - clean
    - basebox
    - basebox.symlink
    - basebox.modify_bash_env
    - network
    - network.cluster
    - users
    - lastpass
    - lastpass.login
    - lastpass.github_keys
    - python
    - conda
    - logging
    - supervisord
    - supervisord.logging_server
    - supervisord.start
    - salt_master
