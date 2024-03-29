#!/bin/sh

# debugging
# set -x

# set "fail on error" in bash
set -e

red='\033[1;31m'
green='\033[1;32m'
yellow='\033[1;33m'
purple='\033[1;34m'
magenta='\033[1;35m'
cyan='\033[1;36m'
white='\033[1;37m'

echo -e ${white}"Enter the full path to the working directory."
read dir
cd $dir
count=$(find . -name '*.md' | wc -l)
echo -e ${yellow}"The working directory is $dir and contains $count .md files."
echo -e ${cyan}"Renaming $count .md files in the working directory 'index.md'."

for file in **/*.md *.md;

do 
  dir=$(echo $file | cut -d. -f1);
  mkdir -p $dir;
  mv $file $dir/index.md;
done

echo -e ${green}"Successfully renamed $count .md files."
