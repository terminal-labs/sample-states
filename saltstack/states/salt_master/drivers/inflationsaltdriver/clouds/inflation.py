from __future__ import absolute_import
import logging

from salt.exceptions import SaltCloudSystemExit
from salt.utils.timeout import wait_for
import salt.config as config
import salt.utils.cloud as cloud

from salt.utils.inflation import (
    vb_get_vm_list,
    vb_get_vm_exists,
    vb_get_vm_address,
    vb_clone_vm,
    vb_destroy_vm,
    vb_stop_vm,
    vb_start_vm,
    vb_util_treat_vm_dict,
)

log = logging.getLogger(__name__)

# The name salt will identify the lib by
__virtualname__ = 'inflation'

def __virtual__():
    '''
    This function determines whether or not
    to make this cloud module available upon execution.
    Most often, it uses get_configured_provider() to determine
     if the necessary configuration has been set up.
    It may also check for necessary imports decide whether to load the module.
    In most cases, it will return a True or False value.
    If the name of the driver used does not match the filename,
     then that name should be returned instead of True.

    @return True|False|str
    '''
    return __virtualname__


def get_configured_provider():
    """
    Return the first configured instance.
    """
    configured = config.is_provider_configured(
        __opts__,
        __active_provider_name__ or __virtualname__,
        ('ssh_username',)  # keys we need from the provider configuration
    )
    return configured


def create(vm_info):
    """
    Creates a virtual machine from the given VM information.
    This is what is used to request a virtual machine to be created by the
    cloud provider, wait for it to become available,
    and then (optionally) log in and install Salt on it.

    Fires:
        "starting create" : This event is tagged salt/cloud/<vm name>/creating.
        The payload contains the names of the VM, profile and provider.

    @param vm_info
            {
                name: <str>
                profile: <dict>
                driver: <provider>:<profile>
                clonefrom: <vm_name>
            }
    @type vm_info dict
    @return dict of resulting vm. !!!Passwords can and should be included!!!
    """

    try:
        # Check for required profile parameters before sending any API calls.
        if vm_info['profile'] and config.is_profile_configured(
            __opts__,
            __active_provider_name__ or 'inflation',
            vm_info['profile']
        ) is False:
            return False
    except AttributeError:
        pass

    vm_name = vm_info["name"]
    deploy = config.get_cloud_config_value(
        'deploy', vm_info, __opts__, search_global=False, default=True
    )
    wait_for_ip_timeout = config.get_cloud_config_value(
        'wait_for_ip_timeout', vm_info, __opts__, default=60
    )
    boot_timeout = config.get_cloud_config_value(
        'boot_timeout', vm_info, __opts__, default=60 * 1000
    )
    power = config.get_cloud_config_value(
        'power_on', vm_info, __opts__, default=False
    )
    key_filename = config.get_cloud_config_value(
        'private_key', vm_info, __opts__, search_global=False, default=None
    )

    log.debug("Going to fire event: starting create")

    # to create the virtual machine.
    request_kwargs = {
        'name': vm_info['name'],
        'clone_from': vm_info['clonefrom']
    }
    vb_stop_vm(vm_info['clonefrom'])
    vb_clone_vm(vm_info['name'], vm_info['clonefrom'])

    # Booting and deploying if needed
    if power:
        vb_start_vm(vm_info['name'])
        ip = wait_for(vb_get_vm_address, timeout=60, step=1, default=[], func_kwargs={'name': vm_info['name']})

        log.info("[ {0} ] IPv4 is: {1}".format(vm_info['name'], ip))
        # ssh or smb using ip and install salt only if deploy is True
        if deploy:
            vm_info['ssh_host'] = ip
            ret = __utils__['cloud.bootstrap'](vm_info, __opts__)

    return ret


def list_nodes_full(kwargs=None, call=None):
    """
    All information available about all nodes should be returned in this function.
    The fields in the list_nodes() function should also be returned,
    even if they would not normally be provided by the cloud provider.

    This is because some functions both within Salt and 3rd party will break if an expected field is not present.
    This function is normally called with the -F option:

    .. code-block:: bash
        salt-cloud -F


    @param kwargs:
    @type kwargs:
    @param call:
    @type call:
    @return:
    @rtype:
    """
    if call == 'action':
        raise SaltCloudSystemExit(
            'The list_nodes_full function must be called '
            'with -f or --function.'
        )

    machines = {}

    for machine in vb_get_vm_list():
        name = machine.get("name")
        if name:
            machines[name] = vb_util_treat_vm_dict(machine)
            del machine["name"]

    return machines


def list_nodes(kwargs=None, call=None):
    """
    This function returns a list of nodes available on this cloud provider, using the following fields:

    id (str)
    image (str)
    size (str)
    state (str)
    private_ips (list)
    public_ips (list)

    No other fields should be returned in this function, and all of these fields should be returned, even if empty.
    The private_ips and public_ips fields should always be of a list type, even if empty,
    and the other fields should always be of a str type.
    This function is normally called with the -Q option:

    .. code-block:: bash
        salt-cloud -Q


    @param kwargs:
    @type kwargs:
    @param call:
    @type call:
    @return:
    @rtype:
    """

    if call == 'action':
        raise SaltCloudSystemExit(
            'The list_nodes function must be called '
            'with -f or --function.'
        )

    attributes = [
        "id",
        "image",
        "state",
        "private_ips",
        "public_ips",
    ]
    return cloud.list_nodes_select(
        list_nodes_full('function'), attributes, call,
    )


def list_nodes_select(call=None):
    """
    Return a list of the VMs that are on the provider, with select fields
    """
    return cloud.list_nodes_select(
        list_nodes_full('function'), __opts__['query.selection'], call,
    )


def destroy(name, call=None):
    """
    This function irreversibly destroys a virtual machine on the cloud provider.
    Before doing so, it should fire an event on the Salt event bus.

    The tag for this event is `salt/cloud/<vm name>/destroying`.
    Once the virtual machine has been destroyed, another event is fired.
    The tag for that event is `salt/cloud/<vm name>/destroyed`.

    Dependencies:
        list_nodes

    @param name:
    @type name: str
    @param call:
    @type call:
    @return: True if all went well, otherwise an error message
    @rtype: bool|str
    """
    log.info("Attempting to delete instance %s", name)

    vb_stop_vm(name)
    vb_destroy_vm(name)


def start(name, call=None):
    """
    Start a machine.
    @param name: Machine to start
    @type name: str
    @param call: Must be "action"
    @type call: str
    """
    if call != 'action':
        raise SaltCloudSystemExit(
            'The instance action must be called with -a or --action.'
        )

    log.info("Starting machine: %s", name)
    vb_start_vm(name)


def stop(name, call=None):
    """
    Stop a running machine.
    @param name: Machine to stop
    @type name: str
    @param call: Must be "action"
    @type call: str
    """
    if call != 'action':
        raise SaltCloudSystemExit(
            'The instance action must be called with -a or --action.'
        )

    log.info("Stopping machine: %s", name)
    vb_stop_vm(name)
