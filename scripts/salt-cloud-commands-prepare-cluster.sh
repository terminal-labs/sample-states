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

echo "pinging minions"
saltmaster "*" "test.ping"

echo "getting minions ip addresses"
saltmaster "*" "network.ip_addrs"

echo "configuring basic cluster nodes"
saltmaster "*" "state.sls cluster_init"

echo "set reboot round grain - first run"
saltmaster "*" "grains.setval reboot_round 0"

echo "syncing all salt resources nodes"
saltmaster "*" "saltutil.sync_all"

echo "updateing mine functions on all nodes"
saltmaster "*" "mine.update"

echo "set hostname"
saltmaster "*" "state.sls cluster_init.set_hostname"

echo "set hostname grain"
saltmaster "*" "state.sls cluster_init.set_hostname_grain"

echo "set cluster nodes grain"
saltmaster "*" "state.sls cluster_init.set_cluster_nodes_grain"

echo "set cluster fqdn"
saltmaster "*" "state.sls cluster_init.set_cluster_fqdn"

echo "setting up ssh key pairs for salt"
saltmaster "*" "ssh.set_auth_key vagrant $public_key enc='rsa'"

echo "setting up ssh key pairs for universal login"
saltmaster "*" "state.sls cluster_init.distribute_ssh_keys_for_universal_login"

echo "setting up setup passwordless sudo"
saltmaster "*" "state.sls cluster_init.setup_passwordless_sudo"

echo "accept host keys"
saltmaster "master" "state.sls cluster_init.accept_hostkeys"

echo "copy known_hosts file for salt distribution"
saltmaster "master" "state.sls cluster_init.prepare_known_hosts_for_distribution"

echo "distribute known_hosts file"
saltmaster "*" "state.sls cluster_init.distribute_known_hosts_file"

echo "run highstate - first run"
saltmaster "*" "state.highstate"

sleep 60s # Waits 60 seconds for minions to reboot. We need more reliable way to deterministically delay this scirpt untill all minoins are back up.

echo "pinging minions after first reboot round"
saltmaster "*" "test.ping"

echo "set reboot round grain - second run"
saltmaster "*" "grains.setval reboot_round 1"

echo "run highstate - second run"
saltmaster "*" "state.highstate"

sleep 60s # Waits 60 seconds for services to load. We need more reliable way to deterministically delay this scirpt untill all minoins are back up.

if [ -f /home/saltmaster/salt_controlplane/etc/salt/keystone.sls ]; then
  echo "run keystone state"
  saltmaster "*" "state.sls keystone"
fi

echo "done"
echo "cluster is ready"
