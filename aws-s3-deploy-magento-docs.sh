#!/bin/bash

# This script automates the following steps:
#   1. Prompt user to choose an environment (e.g., personal, staging, production).
#   4. Copy files between environments based on choices.

# To run this script, you must:
#   - Generate AWS S3 access keys
#   - Download and install the AWS CLI tool
#   - Configure your AWS CLI tool with your AWS access keys
#   - Download this script https://github.com/jeff-matthews/scripts/blob/master/aws-s3-deploy-magento-docs.sh
# See https://wiki.corp.magento.com/display/MERCHDOCS/Working+with+S3.

cat << "EOF"

________                .__                     __________
\______ \   ____ ______ |  |   ____ ___.__. ____\______   \
 |   |   \_/ __ \\____ \|  |  /  _ <   |  |/ __ \|      __/
 |   |    \  ___/|  |_> >  |_(  <_> )___  \  ___/|   |    \
/_______  /\___  >   __/|____/\____// ____|\___  >___|__  /
        \/     \/|__|               \/         \/       \/

EOF

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

########################
# Choose an environment# 
########################
echo -e ${white}"Which environment do you want to deploy?" ${cyan}
  select environment in "personal" "staging"; do
    case $environment in
      personal) personal="s3://docs.magedevteam.com"
      break;;
      staging) staging="s3://docs.magedevteam.com"
      break;;
      *) echo -e ${red}Invalid option! Enter 1 or 2.
    esac
  done 

##############################
# Choose a deployment method #
##############################
echo -e ${white}"Do you want to deploy files from your local file system? Choose "No" to copy files between s3 directories/buckets." ${cyan}
select yn in "Yes" "No"; do
  case $yn in
    Yes)
    if [ "$environment" = "personal" ]; then
      # deploy all local files from the current directory to your personal directory on the S3 staging bucket
      echo -e ${white}"Enter the name of your personal s3 directory and press [ENTER]: "
      read name
      echo -e ${yellow}"Uploading the contents of the current local directory to your personal S3 staging environment..."
      # pass the s3 path ($name) to the aws s3 sync command
      aws s3 sync . $personal/$name/ --dryrun;
      echo -e ${green}"Deployment complete!"
      exit
    else [ "$environment" = "staging" ];
      echo -e ${yellow}"Uploading the contents of the current local directory to the main S3 staging environment..."
      # deploy all local files from the current directory to staging
      aws s3 sync . $staging/ --dryrun;
      echo -e ${green}"Deployment complete!"
      exit
    fi
    break;;
    No)
    echo -e ${white}"Do you want to copy files between directories on staging?" ${cyan}
    select list in "Yes" "No"; do
      case $list in
        Yes)
        if [ "$environment" = "personal" ]; then
          # specify which directory to copy FROM
          echo -e ${white}"Enter the S3 SOURCE directory and press [ENTER]: " ${cyan}
          read custom
          # specify which directory to copy TO
          echo -e ${white}"Enter the S3 DESTINATION directory and press [ENTER]: " ${cyan}
          read name
          # copy files from the custom directory to the personal directory
          aws s3 sync s3://docs.magedevteam.com/$custom/ s3://docs.magedevteam.com/$name/ --exclude ".git/" --dryrun;
          echo -e ${green}"Deployment complete!"
          exit
        else [ "$environment" = "staging" ]
          # specify which directory to copy from
          echo -e ${white}"Enter the S3 SOURCE directory and press [ENTER]: " ${cyan}
          read custom
          # copy files from the custom directory to the staging directory
          aws s3 sync s3://docs.magedevteam.com/$custom/ $staging/ --dryrun;
          exit
        fi
        break;;
        No)
        echo -n ${red}"Error: Production deployment logic disabled. You must copy files between directories on staging or from your local file system. Exiting... " ${cyan}
        exit 1
      esac
    done
  esac
done