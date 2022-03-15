#!/bin/sh

# debugging
set -x

# set "fail on error" in bash
set -e

echo -e ${white}"Enter the full path to the working directory." ${cyan}
read dir
 
cd $dir

echo "Changed to $dir"

for file in **/*.md *.md;

do 
  dir=$(echo $file | cut -d. -f1);
  mkdir -p $dir;
  mv $file $dir/index.md;
done
