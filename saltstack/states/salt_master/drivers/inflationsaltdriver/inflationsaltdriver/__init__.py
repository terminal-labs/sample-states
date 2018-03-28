import requests
import json
import sys
import os

from os.path import expanduser

HOME = expanduser("~")
PROJECT_LOCATION = os.path.dirname(os.path.realpath(__file__))

with open(os.path.join(HOME, 'inflation_driver_config.json'), 'r') as f:
    SETTINGS = json.load(f)
inflation_driver_url = SETTINGS['inflation-driver-url']

def vbox_cli(cmd):
    try:
        cli_output = requests.post(inflation_driver_url, json={"cmd":cmd})
    except requests.exceptions.RequestException:
        print "It looks like the vbox api server is not running"
        sys.exit(0)
    return cli_output.text

def list_vms():
    cmd = "vboxmanage list vms"
    return vbox_cli(cmd)

def list_running_vms():
    cmd = "vboxmanage list runningvms"
    return vbox_cli(cmd)

def list_hdds():
    cmd = "vboxmanage list hdds"
    return vbox_cli(cmd)

def stop_vm(name):
    cmd = "vboxmanage controlvm {} poweroff".format(name)
    return vbox_cli(cmd)

def start_vm(name):
    cmd = "vboxmanage startvm {} --type headless".format(name)
    return vbox_cli(cmd)

def delete_vm(name):
    cmd = "vboxmanage unregistervm {} --delete".format(name)
    return vbox_cli(cmd)

def clone_vm(name, clonefrom):
    cmd = "vboxmanage clonevm {} --name {} --register".format(clonefrom, name)
    return vbox_cli(cmd)

def get_vm_address(name):
    cmd = "vboxmanage guestproperty enumerate {}".format(name)
    return vbox_cli(cmd)
