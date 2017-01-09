#!/bin/bash

# debugging
#set -xv

echo Do you want to deploy the latest tarball?
select yn in "Yes" "No"; do
  case $yn in
    Yes)
    # find the latest tarball, print only the filename, and set as a variable
    file=$(aws s3 ls s3://affinipay-qa/assets/dev-docs/master/ | sort -n | tail -1 | awk '{print $4}')

    # download the file by passing the variable to the aws s3 cp command
    aws s3 cp s3://affinipay-qa/assets/dev-docs/master/$file .;
    break;;
    No) exit;;
  esac
done
