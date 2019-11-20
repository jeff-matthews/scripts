#!/bin/bash

target="~/git/magento/devdocs/guides/v2.1/"

echo -e ${white}"Enter the file you want to find" ${cyan}
read name

output=$( find "$target" -name "$name" 2> /dev/null )

if [[ -n "$output" ]]; then
    echo "$output"
else
    echo "No match found"
fi