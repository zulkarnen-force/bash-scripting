#!/bin/bash

databases=(
   
)

for db in "${databases[@]}"; do
    curl -sSL https://raw.githubusercontent.com/zulkarnen-force/bash-scripting/main/rclone/backup_database_host.bash | bash -s -- --db_type mysql --db_name $db --password Dataku_2023 -b simades --username root --remote-name pcloud706 --retain 3 >> /var/log/backup.log 2>&1
done

