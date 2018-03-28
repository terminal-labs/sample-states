/etc/sudoers:
  file.append:
    - text:
      - "#includedir /etc/sudoers.d"

/etc/sudoers.d/vagrant:
  file.append:
    - text:
      - "vagrant ALL=(ALL) NOPASSWD:ALL"
