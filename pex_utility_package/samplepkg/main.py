# requests isn't actually used, but this demonstrates it being available in main.py
import requests
import click

@click.command()
def hello(count, name):
    """Simple program that greets with hello"""
    click.echo('Hello')

if __name__ == '__main__':
    hello()
