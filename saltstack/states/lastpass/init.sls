install_lastpass_debs:
  pkg.installed:
    - pkgs:
      - build-essential
      - libcurl3
      - libxml2
      - libssl-dev
      - libxml2-dev
      - libcurl4-openssl-dev
      - openssl
      - pinentry-curses
      - cmake
      - pkg-config
      - xclip
      - git

clone_lastpass_rep:
  git.latest:
    - name: https://github.com/lastpass/lastpass-cli.git
    - target: /rambo/src/lastpass-cli

lastpass_cmake:
  cmd.run:
    - name: cmake .
    - cwd: /rambo/src/lastpass-cli

lastpass_make:
  cmd.run:
    - name: make
    - cwd: /rambo/src/lastpass-cli

lastpass_install:
  cmd.run:
    - name: make install
    - cwd: /rambo/src/lastpass-cli

remove_lastpass_build_dir:
  cmd.run:
    - name: rm -rf /rambo/src/lastpass-cli

remove_build_src_dir:
  cmd.run:
    - name: rm -rf /rambo/src

create_primary_lastpass_dir:
  file.directory:
    - name: /home/{{ grains['deescalated_user'] }}/.config/lastpass
    - user: {{ grains['deescalated_user'] }}
    - group: {{ grains['deescalated_user'] }}
    - makedirs: True

create_secondary_lastpass_dir:
  file.directory:
    - name: /home/{{ grains['deescalated_user'] }}/.local/share/lpass
    - user: {{ grains['deescalated_user'] }}
    - group: {{ grains['deescalated_user'] }}
    - makedirs: True

create_tertiary_lastpass_dir:
  file.directory:
    - name: /run/user/1000/lpass
    - makedirs: True
