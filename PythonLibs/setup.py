#!/usr/bin/env python
__usage__ = "setup.py command [--options]"
__description__ = "standard install script"
__author__ = "Isaac Legred (isaac.legred@ligo.org)"

#-------------------------------------------------

from setuptools import (setup, find_packages)
import glob

setup(
    name = 'pyparametric',
    version = '0.0',
    author = __author__,
    description = __description__,
    license = 'MIT',
    scripts = glob.glob('bin/*'),
    packages = find_packages(),
    data_files = [],
    requires = [],
)
