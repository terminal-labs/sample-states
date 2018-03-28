import subprocess

def test():
    return 'custom modules test looks good'

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
