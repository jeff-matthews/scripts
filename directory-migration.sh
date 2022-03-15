#!/bin/sh
set -e

echo “Enter dir”
read dir
 
cd $dir

echo "Changed to $dir"

for file in **/*.md *.md;

do 
  dir=$(echo $file | cut -d. -f1);
  mkdir -p $dir;
  mv $file $dir/index.md;
done
