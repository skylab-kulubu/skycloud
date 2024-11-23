#!/bin/bash

docker compose exec -u www-data nc php occ --no-warnings app:install forms
docker compose exec -u www-data nc php occ --no-warnings app:install richdocuments
docker compose exec -u www-data nc php occ --no-warnings app:install richdocumentscode

# ARM64 Collabora App
# docker compose exec -u www-data nc php occ --no-warnings app:install richdocumentscode_arm64


docker compose exec -u www-data nc php occ --no-warnings app:install contacts
docker compose exec -u www-data nc php occ --no-warnings app:install mail
docker compose exec -u www-data nc php occ --no-warnings app:install spreed



# docker compose exec --user www-data nc php occ config:app:set richdocuments wopi_url --value https://collabora:9980 
# docker compose exec --user www-data nc php occ richdocuments:activate-config

# # docker compose
# docker compose exec --user www-data nc php occ config:app:set richdocuments wopi_url --value https://collabora:9980 
# docker compose exec --user www-data nc php occ richdocuments:activate-config

# GUI "Administration Settings" > Administration > Office 
# (https://cloud.mydomain/settings/admin/richdocuments) 
