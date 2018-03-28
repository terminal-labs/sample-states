delete_salt_controlplane:
  file.absent:
    - name: /home/saltmaster/salt_controlplane

delete_salt_src:
  file.absent:
    - name: /home/saltmaster/salt_src
    
delete_vboxsaltdriver_src:
  file.absent:
    - name: /home/saltmaster/vboxsaltdriver_src
