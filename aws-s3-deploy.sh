#!/bin/bash

cat << "EOF"

________                .__                 ________
\______ \   ____ ______ |  |   ____ ___.__. \______ \   ____   ____   ______
 |    |  \_/ __ \\____ \|  |  /  _ <   |  |  |    |  \ /  _ \_/ ___\ /  ___/
 |    `   \  ___/|  |_> >  |_(  <_> )___  |  |    `   (  <_> )  \___ \___ \
/_______  /\___  >   __/|____/\____// ____| /_______  /\____/ \___  >____  >
        \/     \/|__|               \/              \/            \/     \/

EOF

# debugging
set -xv

# To run this script, you must:
#   - Sign up for an AWS S3 account
#   - Have access to the relevant AWS S3 buckets
#   - Set up your AWS CLI environment (http://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-set-up.html)

echo Do you want to deploy the latest build?
select yn in "Yes" "No"; do
  case $yn in
    Yes)
    echo Downloading the latest tarball from AWS S3...

    # find the latest tarball, print only the filename, and set as a variable
    file=$(aws s3 ls s3://affinipay-qa/assets/dev-docs/master/ | sort -n | tail -1 | awk '{print $4}')

    # download the file by passing the variable to the aws s3 cp command
    aws s3 cp s3://affinipay-qa/assets/dev-docs/master/$file .;

    # extract tarball to web server directory
    # echo Deploying the latest tarball to the web server...
    # sudo tar -xvzf $file -C /home/affinipay/www/doc-site
    break;;

    No)
    echo If No, you must manually enter the filename associated with the tarball you want to deploy.
    echo Enter the filename of the tarball you want to deploy and press enter:
    read filename
    # download the specified tarball
    aws s3 cp s3://affinipay-qa/assets/dev-docs/master/$filename .;
    exit;;
  esac
done
