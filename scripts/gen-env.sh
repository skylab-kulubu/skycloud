#!/bin/bash

generate_password() {
  echo $(openssl rand -base64 12)
}

generate_nextcloud() {
  env_file="nextcloud/.env"
  content=$(
    cat <<NEXTCLOUDENV
MARIADB_PASSWORD=$db_password
MARIADB_DATABASE=nextcloud
MARIADB_USER=nextcloud
MARIADB_HOST=nextcloud-db
NEXTCLOUD_ADMIN_USER=nextcloud
NEXTCLOUD_ADMIN_PASSWORD=$nextcloud_admin_password
NEXTCLOUD_LOG_FILE=/var/log/nextcloud/nextcloud.log
PHP_LOG_FILE=/var/log/php/error.log
NEXTCLOUDENV
  )
  echo $content | tee $env_file
}

generate_mariadb() {
  env_file="mariadb/.env"
  content=$(
    cat <<MARIADB_ENV
MARIADB_ROOT_PASSWORD=$db_root_password
MARIADB_PASSWORD=$db_password
MARIADB_DATABASE=nextcloud
MARIADB_USER=nextcloud
MYSQL_GENERAL_LOG=1
MYSQL_GENERAL_LOG_FILE=/var/log/mysql/mariadb.log
MYSQL_LOG_ERROR=/var/log/mysql/mariadb-error.log
MARIADB_ENV
  )
  echo $content | tee $env_file
}

generate_collabora() {
  env_file="collabora/.env"
  content=$(
    cat <<COLLABORA_ENV
aliasgroup1=https://code.$domain:443
username=admin
password=$code_password
dictionaries=en_US,tr_TR
extra_params='--o=ssl.enable=false --o:ssl.termination=true --o:user_interface.mode=compact --o:logging.level=warning'
COLLABORA_ENV
  )
  echo $content | tee $env_file
}
db_password=generate_password
db_root_password=generate_password
code_password=generate_password
nextcloud_admin_password=generate_password
domain=${1:-domain.tld}
generate_nextcloud
generate_mariadb
generate_collabora
find . -type f -iname ".env" -exec sed -i "s/\ /\n/g" {} \;
