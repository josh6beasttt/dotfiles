#!/usr/bin/env python

import argparse
import os
import subprocess
import sys
import pip

# parser
parser = argparse.ArgumentParser()
parser.add_argument('--list', action='store_true')
parser.add_argument('--sync', action='store_true')
parser.add_argument('--force', action='store_true')

args = parser.parse_args()

if len(sys.argv) == 1:
   parser.print_help()


def install(package):
   try:
       subprocess.call(["%s --help" % package])
   except OSError as e:
       pass


def commands():
   if args.list:
       somecommand = subprocess.Popen("dotfiles -C %s/.dotfilessrc -l" % (CURRENT_DIR), stdout=subprocess.PIPE, shell=True)
       out, err = somecommand.communicate()
       print out

   if args.sync:
       somecommand = subprocess.Popen("dotfiles -C %s/.dotfilessrc -s" % (CURRENT_DIR), stdout=subprocess.PIPE, shell=True)
       out, err = somecommand.communicate()
       print out

   if args.force:
       somecommand = subprocess.Popen("dotfiles -C %s/.dotfilessrc -f -s" % (CURRENT_DIR), stdout=subprocess.PIPE, shell=True)
       out, err = somecommand.communicate()
       print out


if __name__ == '__main__':
   CURRENT_DIR = os.path.dirname(os.path.realpath(__file__))
   install('dotfiles')
   commands()

