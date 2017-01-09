#!/bin/bash

# debugging
#set -xv

# To run this script, you must:
#   - Sign up for an AWS S3 account
#   - Have access to the relevant AWS S3 buckets
#   - Set up your AWS CLI environment (http://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-set-up.html)

echo Do you want to deploy the latest tarball?
select yn in "Yes" "No"; do
  case $yn in
    Yes)
    echo Downloading the latest tarball...
    # find the latest tarball, print only the filename, and set as a variable
    file=$(aws s3 ls s3://affinipay-qa/assets/dev-docs/master/ | sort -n | tail -1 | awk '{print $4}')
    # download the file by passing the variable to the aws s3 cp command
    aws s3 cp s3://affinipay-qa/assets/dev-docs/master/$file .;
    echo Deploying the latest tarball to the web server...
    # extract tarball to web server directory
    sudo tar -xvzf $file -C /home/affinipay/www/doc-site --overwrite
    echo Successfully deployed the latest tarball!
    break;;
    No) If No, you must manually enter the filename associated with the tarball you want to deploy.
    echo Enter the filename of the tarball you want to deploy and press enter:
    read filename
    aws s3 cp s3://affinipay-qa/assets/dev-docs/master/$filename .;
    exit;;
  esac
done
