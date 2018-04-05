import os
import requests
import click

@click.group()
@click.pass_context
def cli(ctx):
    pass

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
