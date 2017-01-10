#!/bin/bash

cat << "EOF"

________                .__                     __________
\______ \   ____ ______ |  |   ____ ___.__. ____\______   \
 |   |   \_/ __ \\____ \|  |  /  _ <   |  |/ __ \|      __/
 |   |    \  ___/|  |_> >  |_(  <_> )___  \  ___/|   |    \
/_______  /\___  >   __/|____/\____// ____|\___  >___|__  /
        \/     \/|__|               \/         \/       \/

EOF

# debugging
#set -x

# set "fail on error" in bash
set -e

# To run this script, you must:
#   - Sign up for an AWS S3 account
#   - Have access to the relevant AWS S3 buckets
#   - Set up your AWS CLI environment (http://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-set-up.html)

red='\033[1;31m'
green='\033[1;32m'
yellow='\033[1;33m'
purple='\033[1;34m'
magenta='\033[1;35m'
cyan='\033[1;36m'
white='\033[1;37m'

#####################
# Choose a branch   #
#####################
echo -e ${white}"Which branch do you want to deploy?" ${cyan}
  select branch in "master" "qa" "production"; do
    case $branch in
      master) master=s3://affinipay-qa/assets/dev-docs/master
      break;;
      qa) qa=s3://affinipay-qa/assets/dev-docs/qa
      break;;
      production) production=s3://affinipay-qa/assets/dev-docs/production
      break;;
      *) echo -e ${red}Invalid option! Enter 1, 2, or 3.
    esac
  done

##################
# Choose a build #
##################
echo -e ${white}"Do you want to deploy the latest build? Select "No" to specify an older build." ${cyan}
select yn in "Yes" "No"; do
  case $yn in
    Yes)
    echo -e ${yellow}"Downloading the latest tarball from AWS S3..."
    if [ "$branch" = "master" ]; then
      # find the latest tarball, print only the filename, and set as a variable
      file=$(aws s3 ls $master/ | sort -n | tail -1 | awk '{print $4}')
      # download the file by passing the variable to the aws s3 cp command
      aws s3 cp $master/$file .;
      echo -e ${green}"Download complete!"
    elif [ "$branch" = "qa" ]; then
      # find the latest tarball, print only the filename, and set as a variable
      file=$(aws s3 ls $qa/ | sort -n | tail -1 | awk '{print $4}')
      # download the file by passing the variable to the aws s3 cp command
      aws s3 cp $qa/$file .;
      echo -e ${green}"Download complete!"
    else [ "$branch" = "production" ]
      # find the latest tarball, print only the filename, and set as a variable
      file=$(aws s3 ls $production/ | sort -n | tail -1 | awk '{print $4}')
      # download the file by passing the variable to the aws s3 cp command
      aws s3 cp $production/$file .;
      echo -e ${green}"Download complete!"
    fi
    break;;
    No)
    echo -e ${white}"Do you want to see a list of builds for this branch?" ${cyan}
    select list in "Yes" "No"; do
      case $list in
        Yes)
        if [ "$branch" = "master" ]; then
          # list tarball filenames in master
          aws s3 ls $master/;
        elif [ "$branch" = "qa" ]; then
          # list tarball filenames in qa
          aws s3 ls $qa/;
        else [ "$branch" = "production" ]
          # list tarball filenames in production
          aws s3 ls $production/;
        fi
        echo -n -e ${white}"Enter the filename of the build tarball you want to deploy and press [Enter]: "
        read filename
        break;;
        No)
        echo -n -e ${white}"Enter the filename of the build tarball you want to deploy and press [Enter]: "
        read filename
        break;;
        *) echo -e ${red}"Invalid option! Enter 1 or 2."
      esac
    done
    ##############################
    # Download the build tarball #
    ##############################
    if [ "$branch" = "master" ]; then
      # download the specified tarball
      aws s3 cp $master/$filename .
      echo -e ${green}"Download complete!"
    elif [ "$branch" = "qa" ]; then
      aws s3 cp $qa/$filename .
      echo -e ${green}"Download complete!"
    else [ "$branch" = "production" ]
      aws s3 cp $production/$filename .
      echo -e ${green}"Download complete!"
    fi
    break;;
    *) echo -e ${red}Invalid option! Enter 1 or 2.
  esac
done
#################################################################
# Extract the build tarball to the correct web server directory #
#################################################################
echo -e ${white}"Do you want to deploy?" ${cyan}
  select deploy in "Yes" "No"; do
    case $deploy in
      Yes)
      if [ "$yn" = "No" ]; then
        # extract tarball to web server directory
        echo -e ${yellow}"Extracting build tarball to the web server directory..."
        tar -xvzf $filename -C /home/affinipay/www/doc-site
        echo -e ${green}"Extraction complete!"
      else [ "$yn" = "Yes" ]
        # extract tarball to web server directory
        echo -e ${yellow}"Extracting build tarball to the web server directory..."
        tar -xvzf $file -C /home/affinipay/www/doc-site
        echo -e ${green}"Extraction complete!"
      fi
      break;;
      No)
      break;;
      *) echo -e ${red}Invalid option! Enter 1 or 2.
    esac
  done
