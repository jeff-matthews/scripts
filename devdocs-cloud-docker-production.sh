#!/bin/bash
set -e

MAGENTO_VERSION=2.3.7
CLOUD_DOCKER_VERSION=1.2.2
PHP=7.4

echo 'Preparing for installation'

if [ -d "magento-cloud-${MAGENTO_VERSION}" ] 
then
    cd magento-cloud-${MAGENTO_VERSION}

    echo "Clearing existing template"
    rm -rf vendor composer.lock var/log/*

    echo 'Clearing existing projects'
    docker-compose down --volume

    echo 'Pruning Docker resources'
    docker system prune --force --all
else
    echo 'Starting official procedure from Step 1 (https://devdocs.magento.com/cloud/docker/docker-mode-production.html)'

    echo "Downloading a template for Magento ${MAGENTO_VERSION}"
    wget -nc https://github.com/magento/magento-cloud/archive/${MAGENTO_VERSION}.zip

    echo "Unarchiving"
    unzip -o ${MAGENTO_VERSION}

    echo "Removing the archive"
    rm ${MAGENTO_VERSION}.zip

    cd magento-cloud-${MAGENTO_VERSION}

    echo 'Getting auth.json from global Composer locale'
    cp ~/.composer/auth.json . || exit
fi

echo 'Starting official procedure from Step 3 (https://devdocs.magento.com/cloud/docker/docker-mode-production.html)'

if [ ! -f "auth.json" ]; then
    echo "Add 'auth.json'."
    exit
fi

echo 'Installing the template dependencies and add the default hostname to your /etc/hosts file'
curl https://raw.githubusercontent.com/magento/magento-cloud-docker/${CLOUD_DOCKER_VERSION}/bin/init-docker.sh | bash -s -- --php ${PHP}

echo 'Start the Docker configuration generator'
./vendor/bin/ece-docker build:compose --php ${PHP}

echo 'Build files to containers and run in the background'
docker-compose up --detach

echo 'Build Magento'
docker-compose run build cloud-build

echo 'Deploy Magento'
docker-compose run deploy cloud-deploy

echo 'Run post-deploy hooks'
docker-compose run deploy cloud-post-deploy

echo 'Configure Varnish'
docker-compose run deploy magento-command config:set system/full_page_cache/caching_application 2 --lock-env

echo 'Connect Varnish'
docker-compose run deploy magento-command setup:config:set --http-cache-hosts=varnish

echo 'Clear the cache'
docker-compose run deploy magento-command cache:clean

# docker-compose restart

echo 'Access the local Magento Cloud template'
open http://magento2.docker
