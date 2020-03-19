#!/usr/bin/env python

import os, fnmatch, shutil

#  Pattern to filter
files = ['*.psd', '*.ai', '*.pdf', '*.zip', '*.sketch']

# Source path
source = '/Users/jeffmatthews/git/magento/devdocs/src/'
  
# Destination path
destination = '/Users/jeffmatthews/Desktop/dest/'

for root, dirnames, filenames in os.walk(source):
    for extensions in files:
        for filename in fnmatch.filter(filenames, extensions):
            print (os.path.join(root, filename))
            print (os.path.join(destination, filename))
            shutil.move(os.path.join(root, filename), os.path.join(destination, filename))

print len([name for name in os.listdir(destination) if os.path.isfile(os.path.join(destination, name))])
