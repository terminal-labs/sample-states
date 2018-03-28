modify_bashrc:
  cmd.run:
    - name: sed -i 's/^#force_color_prompt/force_color_prompt/g' .bashrc; sed -i 's/^\s*#alias grep/    alias grep/g' .bashrc
    - cwd: {{ grains['user_home_dir'] }}
    - runas: {{ grains['user'] }}

add_bash_aliases:
  cmd.run:
    - name: echo "alias emacs='emacsclient -a \"\" -t'" > .bash_aliases
    - cwd: {{ grains['user_home_dir'] }}
    - runas: root
