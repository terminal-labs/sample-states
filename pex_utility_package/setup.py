from setuptools import setup
setup (
  name = "myexample",
  packages=['samplepkg'],
  entry_points='''
    [console_scripts]
    tool=samplepkg.main:main
  '''
)
