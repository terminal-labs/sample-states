cluster_nodes:
  grains.list_present:
    - value:
{%- for minion, addr in salt['mine.get']('*', 'inflation.get_primary_address').items() %}
      - {{ minion }}: {{ addr }}
{% endfor %}
