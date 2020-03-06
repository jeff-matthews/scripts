#!/usr/bin/env python

import os
import fnmatch
import shutil

binaries = ['*.psd', '*.ai', '*.pdf', '*.zip', '*.sketch']

for root, dirnames, filenames in os.walk("/Users/jeffmatthews/git/magento/devdocs/src/"):
    for extensions in binaries:
        for filename in fnmatch.filter(filenames, extensions):
            # matches.append(os.path.join(root, filename))
            # matches.append(os.path.abspath(os.getcwd())
            print(os.path.join(root, filename))