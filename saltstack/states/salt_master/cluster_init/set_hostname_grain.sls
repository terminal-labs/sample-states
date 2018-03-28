{% import_text "/etc/hostname" as hostname %}

hostname:
  grains.present:
    - value: {{ hostname }}
