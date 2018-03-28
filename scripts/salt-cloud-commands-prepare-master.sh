#!/usr/bin/env bash
cd /home/saltmaster/salt_venv

function saltmaster { # $1 = location, e.g. 'master' or '*', $2 = command
    start="su saltmaster -c \"cd /home/saltmaster;\
     source salt_venv/bin/activate;\
     python /home/saltmaster/salt_src/scripts/salt '"
    middle="' -c /home/saltmaster/salt_controlplane/etc/salt "
    end=" \""
    command=$start$1$middle$2$end
    eval $command
}

echo "stoping bootstrap salt minion and salt master"

ps aux | grep -ie salt-minion | grep -v grep | awk '{print "kill -9 " $2}' | sh -x
echo "waiting for salt-minion (on master node) to fully go down"
while [[ $(netstat -antp | grep 4505) ]]
do
  sleep 1
  echo "Still waiting for minion to stop"
done

ps aux | grep -ie salt-master | grep -v grep | awk '{print "kill -9 " $2}' | sh -x
echo "waiting for salt-master (on master node) to fully go down"
while [[ $(netstat -antp | grep 4506) ]]
do
  sleep 1
  echo "Still waiting for master to stop"
done

echo "starting salt master service"
su saltmaster -c "cd /home/saltmaster;\
 source salt_venv/bin/activate;\
 /home/saltmaster/salt_venv/bin/python /home/saltmaster/salt_src/scripts/salt-master -c /home/saltmaster/salt_controlplane/etc/salt -d"
echo "starting salt minion service"
su saltmaster -c "cd /home/saltmaster;\
 source salt_venv/bin/activate;\
 sudo /home/saltmaster/salt_venv/bin/python /home/saltmaster/salt_src/scripts/salt-minion -c /home/saltmaster/salt_controlplane/etc/salt -d"

echo "waiting for salt-minion (on master node) to fully boostrap"
while ! test -f "/home/saltmaster/salt_master_root/etc/salt/pki/master/minions_pre/master"
do
  sleep 1
  echo "Still waiting for minion to boostrap"
done

mv /home/saltmaster/salt_master_root/etc/salt/pki/master/minions_pre/master /home/saltmaster/salt_master_root/etc/salt/pki/master/minions
echo "salt-minion (on master node) is up and registered"

echo "waiting for minion (on master node) to connect"
while ! su saltmaster -c "cd /home/saltmaster;\
 source salt_venv/bin/activate;\
 python /home/saltmaster/salt_src/scripts/salt 'master' -c /home/saltmaster/salt_controlplane/etc/salt test.ping --timeout 1" | grep 'True'
do
  sleep 1
  echo "Still waiting for minion to connect"
done

echo "pinging master"
saltmaster "master" "test.ping"

echo "set reboot round grain on master"
saltmaster "master" "grains.setval reboot_round 0"

echo "syncing custom modules on master"
saltmaster "master" "saltutil.sync_modules"

echo "set default grains on master"
saltmaster "master" "grains.setval deescalated_user vagrant"
saltmaster "master" "grains.setval primary_role master"
saltmaster "master" "grains.setval domain test.local"
saltmaster "master" "grains.setval vm_size 8gb"

raw_public_key=$(cat /var/tmp/universal_cluster_key.pub)
FS=' ' read -r -a array <<< "$raw_public_key"
public_key="${array[1]}"

echo "setting salt master ip address"
host_ip_address=$(su saltmaster -c "cd /home/saltmaster;\
 source salt_venv/bin/activate;\
 python /home/saltmaster/salt_src/scripts/salt 'master' -c /home/saltmaster/salt_controlplane/etc/salt inflation.get_primary_address --output newline_values_only --timeout 1")

sed -i -e 's~{{ master_address }}~'"$host_ip_address"'~g' /home/saltmaster/salt_controlplane/etc/salt/cloud.providers

vendor=$(cat /vagrant/.tmp/vendor)

if [ "$vendor" == "digitalocean" ]
then
  personal_access_token=$(cat /vagrant/.tmp/auth_token)
  sed -i -e 's~{{ personal_access_token }}~'"$personal_access_token"'~g' /home/saltmaster/salt_controlplane/etc/salt/cloud.providers
fi

if [ "$vendor" == "aws" ]
then
  personal_access_key=$(cat /vagrant/.tmp/secret_auth_token)
  sed -i -e 's~{{ personal_access_key }}~'"$personal_access_key"'~g' /home/saltmaster/salt_controlplane/etc/salt/cloud.providers
  personal_access_token=$(cat /vagrant/.tmp/auth_token)
  sed -i -e 's~{{ personal_access_token }}~'"$personal_access_token"'~g' /home/saltmaster/salt_controlplane/etc/salt/cloud.providers
fi

lastpass_username=$(cat /vagrant/auth/lastpass/username)
sed -i -e 's~{{ lastpass_username }}~'"$lastpass_username"'~g' /home/saltmaster/salt_controlplane/etc/salt/cloud.providers

lastpass_password=$(cat /vagrant/auth/lastpass/password)
sed -i -e 's~{{ lastpass_password }}~'"$lastpass_password"'~g' /home/saltmaster/salt_controlplane/etc/salt/cloud.providers
