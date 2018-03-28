{% if salt['file.directory_exists']('/home/saltmaster/salt_controlplane/etc/salt') %}
move_known_hosts:
  cmd.run:
    - name: cp /home/vagrant/.ssh/known_hosts /home/saltmaster/salt_controlplane/etc/salt/known_hosts
    - cwd: /home/saltmaster

/home/saltmaster/salt_controlplane/etc/salt/known_hosts:
  file.managed:
    - user: saltmaster
    - group: saltmaster
    - recurse:
      - user
      - group
{% else %}
pass_move_known_hosts:
  cmd.run:
    - name: echo "pass"
{% endif %}
