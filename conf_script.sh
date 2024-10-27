#!/bin/bash

if [[ $1 == 'db'  ]]
then
    if [[ $2 == 'pass'  ]]
    then
        sed -i.bak "s/MARIADB_ROOT_PASSWORD=.*/$3/g" mariadb/.env
        sed -i.bak "s/MYSQL_PASSWORD=.*/$3/g" mariadb/.env
        sed -i.bak "s/database__connection__password=.*/$3/g" ghost/.env
        sed -i.bak "s/MYSQL_PASSWORD=.*/$3/g" nextcloud/.env
    fi
fi

if [[ $1 == 'domain'  ]]
then
    if [[ $2 == 'nextcloud'  ]];then
        sed -i.bak "s/nextcloud\..*\.com/$2/s" nginx/nginx.conf
    elif [[ $2 == 'ghost'  ]];then
        sed -i.bak "s/blog\..*\.com/$2/s" nginx/nginx.conf
    else
        sed -i.bak "s/skylab\.com/$2.com/s"
    fi
elif
fi
