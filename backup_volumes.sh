#!/bin/bash
if [[ $1 == "nextcloud"  ]];then
    docker run --rm --volumes-from nextcloud -v $(pwd):/backup ubuntu tar cvf /backup/backup.tar /nextcloud_backup
elif [[ $1 == "db"  ]];then
    docker run --rm --volumes-from db -v $(pwd):/backup ubuntu tar cvf /backup/backup.tar /db_backup
elif [[ $1 == "onlyoffice"  ]];then
    docker run --rm --volumes-from onlyoffice-document-data -v $(pwd):/backup ubuntu tar cvf /backup/backup.tar /onlyoffice-document-data_backup
    docker run --rm --volumes-from onlyoffice-document-log -v $(pwd):/backup ubuntu tar cvf /backup/backup.tar /onlyoffice-document-log_back
elif [[ $1 == "ghost"  ]];then
    docker run --rm --volumes-from ghost -v $(pwd):/backup ubuntu tar cvf /backup/backup.tar /ghost_backup
elif [[ $1 == "all"  ]];then
    docker run --rm --volumes-from nextcloud -v $(pwd):/backup ubuntu tar cvf /backup/backup.tar /nextcloud_backup
    docker run --rm --volumes-from db -v $(pwd):/backup ubuntu tar cvf /backup/backup.tar /db_backup
    docker run --rm --volumes-from onlyoffice-document-data -v $(pwd):/backup ubuntu tar cvf /backup/backup.tar /onlyoffice-document-data_backup
    docker run --rm --volumes-from onlyoffice-document-log -v $(pwd):/backup ubuntu tar cvf /backup/backup.tar /onlyoffice-document-log_back
    docker run --rm --volumes-from ghost -v $(pwd):/backup ubuntu tar cvf /backup/backup.tar /ghost_backup
else
    echo "Enter valid option:\n-nextcloud\n-db\n-onlyoffice\n-ghost\n-all"
fi

