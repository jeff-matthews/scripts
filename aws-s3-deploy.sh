#!/bin/bash

cat << "EOF"

________                .__                     __________
\______ \   ____ ______ |  |   ____ ___.__. ____\______   \
 |   |   \_/ __ \\____ \|  |  /  _ <   |  |/ __ \|       _/
 |   |    \  ___/|  |_> >  |_(  <_> )___  \  ___/|    |   \
/_______  /\___  >   __/|____/\____// ____|\___  >____|_  /
        \/     \/|__|               \/         \/       \/

EOF

# debugging
# set -xv

# set "fail on error" in bash
set -e

# To run this script, you must:
#   - Sign up for an AWS S3 account
#   - Have access to the relevant AWS S3 buckets
#   - Set up your AWS CLI environment (http://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-set-up.html)

echo Which branch do you want to deploy?
  select branch in "master" "qa" "production"; do
    case $branch in
      master) master=s3://affinipay-qa/assets/dev-docs/master
      break;;
      qa) qa=s3://affinipay-qa/assets/dev-docs/qa
      break;;
      production) production=s3://affinipay-qa/assets/dev-docs/production
      break;;
      *) echo Invalid option! Enter 1, 2, or 3.
    esac
  done

echo Do you want to deploy the latest build? If No, you must manually enter the filename associated with the tarball you want to deploy.
select yn in "Yes" "No"; do
  case $yn in
    Yes)
    echo Downloading the latest tarball from AWS S3...

    if [ "$branch" = "master" ]; then
      # find the latest tarball, print only the filename, and set as a variable
      file=$(aws s3 ls $master/ | sort -n | tail -1 | awk '{print $4}')
      # download the file by passing the variable to the aws s3 cp command
      aws s3 cp $master/$file .;
    elif [ "$branch" = "qa" ]; then
      # find the latest tarball, print only the filename, and set as a variable
      file=$(aws s3 ls $qa/ | sort -n | tail -1 | awk '{print $4}')
      # download the file by passing the variable to the aws s3 cp command
      aws s3 cp $qa/$file .;
    else [ "$branch" = "production" ]
      # find the latest tarball, print only the filename, and set as a variable
      file=$(aws s3 ls $production/ | sort -n | tail -1 | awk '{print $4}')
      # download the file by passing the variable to the aws s3 cp command
      aws s3 cp $production/$file .;
    fi

    # extract tarball to web server directory
    # echo Deploying the latest tarball to the web server...
    # sudo tar -xvzf $file -C /home/affinipay/www/doc-site

    break;;

    No)
    read -p "Enter the filename of the tarball you want to deploy and press enter: " filename

    if [ "$branch" = "master" ]; then
      # download the specified tarball
      aws s3 cp $master/$filename .;
    elif [ "$branch" = "qa" ]; then
      aws s3 cp $qa/$filename .;
    else [ "$branch" = "production" ]
      aws s3 cp $production/$filename .;
    fi

    break;;

    *) echo Invalid option! Enter 1 or 2.

  esac
done
