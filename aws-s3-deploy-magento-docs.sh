#!/bin/bash

# This script automates the following steps:
#   1. Prompt user to choose an environment (e.g., personal, staging, production).
#   2. Prompt user to choose a version (e.g., 2.0, 2.1, 2.2).
#   3. Prompt user to choose a guide (e.g., CE, EE, B2B).
#   4. Copy files between environments based on choices.

# To run this script, you must:
#   - Generate AWS S3 access keys
#   - Download and install the AWS CLI tool
#   - Configure your AWS CLI tool with your AWS access keys
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
set -x

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
  select environment in "personal" "staging" "production"; do
    case $environment in
      personal) personal="s3://docs.magedevteam.com"
      break;;
      staging) staging="s3://docs.magedevteam.com/staging"
      break;;
      production) production="s3://docs.magento.com"
      break;;
      *) echo -e ${red}Invalid option! Enter 1, 2, or 3.
    esac
  done 

# ####################
# # Choose a version # 
# ####################
# echo -e ${white}"Which version do you want to deploy?" ${cyan}
#   select version in 2.0 2.1 2.2; do
#     case $version in
#       2.0) twoo="2.0"
#       break;;
#       2.1) twoone="2.1"
#       break;;
#       2.2) twotwo="/"
#       break;;
#       *) echo -e ${red}Invalid option! Enter 1, 2, or 3.
#     esac
#   done

# ##################
# # Choose a Guide # 
# ##################
# echo -e ${white}"Which guide do you want to deploy?" ${cyan}
#   select guide in CE EE B2B; do
#     case $guide in
#       CE) CE="ce"
#       break;;
#       EE) EE="ee"
#       break;;
#       B2B) B2B="b2b"
#       break;;
#       *) echo -e ${red}Invalid option! Enter 1, 2, or 3.
#     esac
#   done

# # Test
# if [ "$environment" = "personal" ] && [ "$version" = "twotwo" ]; then
#   aws s3 ls $personal/$version/$guide/;
# fi
# break

##############################
# Choose a deployment method #
##############################
echo -e ${white}"Do you want to deploy files from your local file system? Enter "No" to copy files between s3 directories/buckets." ${cyan}
select yn in "Yes" "No"; do
  case $yn in
    Yes)
    echo -e ${yellow}"Uploading the contents of the current local directory to your personal S3 staging environment..."
    if [ "$environment" = "personal" ]; then
      # deploy all local files from the current directory to your personal directory on the S3 staging bucket
      echo -n "Enter the name of your personal s3 directory and press [ENTER]: "
      read name
      # pass the s3 path ($name) to the aws s3 sync command
      aws s3 sync . $personal/$name/ --dryrun;
      echo -e ${green}"Deployment complete!"
    elif [ "$environment" = "staging" ]; then
      # deploy all local files from the current directory to staging
      aws s3 sync . $staging/ --dryrun;
      echo -e ${green}"Deployment complete!"
    else [ "$environment" = "production" ]
      # deploy all local files from the current directory to production
      aws s3 sync . $production/ --dryrun;
      echo -e ${green}"Deployment complete!"
    fi
    break;;
    No)
    echo -e ${white}"Do you want to copy files between directories on staging? Enter "No" to deploy production." ${cyan}
    select list in "Yes" "No"; do
      case $list in
        Yes)
        if [ "$environment" = "personal" ]; then
          # specify which directory to copy FROM
          echo -n ${white}"Enter the name of the s3 directory you want to copy files FROM and press [ENTER]: " ${cyan}
          read custom
          # specify which directory to copy TO
          echo -n ${white}"Enter the name of the s3 directory you want to copy files TO and press [ENTER]: " ${cyan}
          read name
          # copy files from the custom directory to the personal directory
          aws s3 sync s3://docs.magedevteam.com/$custom/ s3://docs.magedevteam.com/$name/ --dryrun;
        else [ "$environment" = "staging" ]
          # specify which directory to copy from
          echo -n ${white}"Enter the name of the s3 directory you want to copy files FROM and press [ENTER]: " ${cyan}
          read custom
          # copy files from the custom directory to the staging directory
          aws s3 sync s3://docs.magedevteam.com/$custom/ $staging/ --dryrun;
        fi
        break;;
        No)
        echo -n -e ${white}"Enter the name of the s3 directory you want to deploy to production and press [ENTER]: " ${cyan}
        read custom
        # copy files from the custom directory to the production directory
        aws s3 sync s3://docs.magedevteam.com/$custom/ $production/ --dryrun;
        break;;  
      esac
    done
  esac
done