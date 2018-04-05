import os
import requests
import click

@click.group()
@click.pass_context
def cli(ctx):
    pass

@cli.command()
def truncate_minion_id():
    file_in = open('/etc/salt/minion')
    lines = file_in.readlines()
    file_in.seek(0)
    content = file_in.read()
    file_in.close()
    
    for line in lines:
        if ":" in line:
            split_line = line.split(":")
            if 'id' in split_line[0]:
                old_id = split_line[1].strip()
                if old_id.count('-') > 0:
                    new_id = old_id.split('-')[0] + '-' + old_id.split('-')[1]
                else:
                    new_id = old_id
                old_id_line = line
                new_id_line =  split_line[0] + ": " +  new_id + "\n"
                new_content = content.replace(old_id_line, new_id_line)
                file_in = open('/etc/salt/minion', 'w')
                file_in.write(new_content)
                file_in.close()

@cli.command()
def truncate_minion_key_names():
    path = '/home/saltmaster/salt_master_root/etc/salt/pki/master/minions'
    if os.path.exists(path):
        filenames = os.listdir(path)
        for filename in filenames:
            if filename.count('-') == 2:
                os.rename(path + '/' + filename, path + '/' + filename.split('-')[0] + '-' + filename.split('-')[1] )
        return "truncated some key names"
    return "minion key path not found"

if __name__ == "__main__":
    cli()
