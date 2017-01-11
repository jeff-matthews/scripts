#!/bin/sh

# This script belongs in the user directory of the user whose credentials appear in the curl command
current_time=$(date "+%Y%m%d%H%M%S")
{{curl -u "username":"password" -O "<downloadURL>"}}
mkdir $current_time
tar xvzf dev-docs.tar.gz -C $current_time
mv $current_time www/$current_time
ln -sfn /var/www/$current_time /var/www/doc-site
{{find /var/www -maxdepth 1 -mindepth 1 -type d -not -name $current_time -exec rm -r "{}" \;}}
