#!/bin/bash
set -ex

MAGENTO_VERSION=2.4.3
CLOUD_DOCKER_VERSION=1.2.4

echo 'Preparing for installation'

if [ -d "magento-cloud-${MAGENTO_VERSION}" ] 
then
    cd magento-cloud-${MAGENTO_VERSION}

    echo 'Clearing existing projects'
    docker-compose down --volume

    echo "Clearing existing template"
    rm -rf vendor composer.lock var/log/*

    # echo 'Pruning Docker resources'
    # docker system prune --force --all
else
    echo 'Starting official procedure from Step 1 (https://devdocs.magento.com/cloud/docker/docker-mode-production.html)'

    echo "Downloading a template for Magento ${MAGENTO_VERSION}"

    git clone --branch ${MAGENTO_VERSION} git@github.com:magento/magento-cloud.git magento-cloud-${MAGENTO_VERSION}

    cd magento-cloud-${MAGENTO_VERSION}

    echo 'Getting auth.json from global Composer locale'
    cp ~/.composer/auth.json . || exit
fi

echo 'Starting official procedure from Step 3 (https://devdocs.magento.com/cloud/docker/docker-mode-production.html)'

if [ ! -f "auth.json" ]; then
    echo "Add 'auth.json'."
    exit
fi

echo 'Updating dependencies'
COMPOSER_MEMORY_LIMIT=-1 composer update

echo 'Start the Docker configuration generator'
./vendor/bin/ece-docker build:compose

echo 'Build files to containers and run in the background'
docker-compose up --detach

echo 'Build Magento'
docker-compose run --rm build cloud-build

echo 'Deploy Magento'
docker-compose run --rm deploy cloud-deploy

echo 'Run post-deploy hooks'
docker-compose run --rm deploy cloud-post-deploy

echo 'Configure Varnish'
docker-compose run --rm deploy magento-command config:set system/full_page_cache/caching_application 2 --lock-env

echo 'Connect Varnish'
docker-compose run --rm deploy magento-command setup:config:set --http-cache-hosts=varnish

echo 'Clear the cache'
docker-compose run --rm deploy magento-command cache:clean

# docker-compose restart

echo 'Access the local Magento Cloud template'
open http://magento2.docker
open http://magento2.docker/admin
open http://magento2.docker:8025/
