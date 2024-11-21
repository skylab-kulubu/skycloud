#!/bin/bash

docker compose exec -u www-data nc php occ --no-warnings app:install forms
# adopt to your system e.g. add sudo, www user etc..
# docker compose exec --user www-data nc php occ app:enable richdocuments
docker compose exec --user www-data nc php occ config:app:set richdocuments wopi_url --value https://collabora:9980 
docker compose exec --user www-data nc php occ richdocuments:activate-config

# docker compose
docker compose exec --user www-data nc php occ config:app:set richdocuments wopi_url --value https://collabora:9980 
docker compose exec --user www-data nc php occ richdocuments:activate-config

# GUI "Administration Settings" > Administration > Office 
# (https://cloud.mydomain/settings/admin/richdocuments) 
