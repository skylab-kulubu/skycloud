#!/bin/bash

set -x

docker exec -u www-data  nextcloud-fpm php occ --no-warnings config:system:get trusted_domains >> trusted_domain.tmp

if ! grep -q "nextcloud-web" trusted_domain.tmp; then
    TRUSTED_INDEX=$(cat trusted_domain.tmp | wc -l);
    docker exec -u www-data  nextcloud-fpm php occ --no-warnings config:system:set trusted_domains $TRUSTED_INDEX --value="nextcloud-web"
fi

rm trusted_domain.tmp

docker exec -u www-data  nextcloud-fpm php occ --no-warnings app:install onlyoffice

docker exec -u www-data  nextcloud-fpm php occ --no-warnings config:system:set onlyoffice DocumentServerUrl --value="/ds-vpath/"
docker exec -u www-data  nextcloud-fpm php occ --no-warnings config:system:set onlyoffice DocumentServerInternalUrl --value="http://onlyoffice-document-server/"
docker exec -u www-data  nextcloud-fpm php occ --no-warnings config:system:set onlyoffice StorageUrl --value="http://nextcloud-web/"
docker exec -u www-data  nextcloud-fpm php occ --no-warnings config:system:set onlyoffice jwt_secret --value="nextcloud"


docker exec -u www-data  nextcloud-fpm php occ --no-warnings app:install forms
