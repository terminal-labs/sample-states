import os
import subprocess

def test():
    return 'custom modules test looks good'

def change_minion_key_names_on_master():
    path = '/home/saltmaster/salt_master_root/etc/salt/pki/master/minions'
    if os.path.exists(path):
        filenames = os.listdir(path)
        for filename in filenames:
            if filename.count('-') == 2:
                os.rename(path + '/' + filename, path + '/' + filename.split('-')[0] + '-' + filename.split('-')[1] )
                return filename
    else:
        return "path does not exist"

def change_minion_id():
    new_id = "minion-12"
    file_in = open('/etc/salt/minion')
    lines = file_in.readlines()
    file_in.seek(0)
    content = file_in.read()
    file_in.close()
    for line in lines:
        if ":" in line:
	    split_line = line.split(":")
            if 'id' in split_line[0]:
                old_id_line = line
                new_id_line =  split_line[0] + ": " +  new_id + "\n"
                new_content = content.replace(old_id_line, new_id_line)
                file_in = open('/etc/salt/minion', 'w')
                file_in.write(new_content)
                file_in.close()

def get_primary_address():
    data = subprocess.check_output(['ip', 'addr'])
    lines = data.split('\n')

    ip_address_candidates = []
    for line in lines:
        line = line.lstrip()
        line = line.rstrip()
        if 'inet ' in line:
            ip = line.split(' ')[1].split('/')[0]
            if not ip.startswith('127') and not ip.startswith('10') and not ip.startswith('192.168'):
                ip_address_candidates.append(ip)

    acceptable_addresses = []
    for _ in range(256):
        acceptable_addresses.append('172.28.128.' + str(_))

    for address in acceptable_addresses:
        if address in ip_address_candidates:
            return address

    if len(ip_address_candidates):
		return ip_address_candidates[0]
