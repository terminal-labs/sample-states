import click
from bash import bash

@click.group()
@click.option('--somefunc', help="do something")
def cli(somefunc):
    pass

@cli.command()
def minion_addrs():
   click.echo(bash('salt "*" -c /home/saltmaster/salt_controlplane/etc/salt network.ip_addrs --log-file logs/saltstack.log --no-color'))

if __name__ == '__main__':
    cli()
