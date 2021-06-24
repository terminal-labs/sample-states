# File: srv/salt/update_vms.sls

yum_update_vms:
  cmd.rum:
    - name: 'sudo yum update -y && yum upgrade -y'
