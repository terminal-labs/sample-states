127.0.1.1:
  host.only:
    - hostnames:
      - {{ grains['hostname'] }}

rm_hosts:
  host.absent:
    - name: {{ grains['hostname'] }}
    - ip: 127.0.1.1

{% if 'cluster_nodes' in grains %}
{% for node in grains['cluster_nodes'] if node != grains['hostname'] %}
{% for hostname, ip in node.items() %}
{{ ip }}:
  host.only:
    - hostnames:
      {% if 'domain' in grains %}
      - {{ hostname }}.{{ grains['domain'] }}
      {% endif %}
      - {{ hostname }}
{% endfor %}
{% endfor %}
{% endif %}
