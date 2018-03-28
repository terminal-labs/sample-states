{%- for minion, addr in salt['mine.get']('*', 'inflation.get_primary_address').items() %}
accept_hostkeys_{{ minion }}:
  cmd.run:
    - name: ssh-keyscan -H {{ minion }} >> ~/.ssh/known_hosts
    - runas: vagrant
{% endfor %}
