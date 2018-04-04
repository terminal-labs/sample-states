# requests isn't actually used, but this demonstrates it being available in main.py
import requests
import click

@click.group()
@click.pass_context
def cli(ctx):
    pass

@cli.command()
def hello():
    """Simple program that emits hello"""
    click.echo('Hello')

main = cli
