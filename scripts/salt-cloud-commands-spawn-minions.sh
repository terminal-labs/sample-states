#!/usr/bin/env bash
cd /home/saltmaster/salt_venv

echo "deploying minions, this may take a few minutes"
su saltmaster -c "cd /home/saltmaster;\
  source salt_venv/bin/activate;\
  python /home/saltmaster/salt_src/scripts/salt-cloud -c /home/saltmaster/salt_controlplane/etc/salt -m /home/saltmaster/salt_controlplane/etc/salt/cloud.map -y -P"
echo "minions deployed"
