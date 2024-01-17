#!/bin/bash
CURRENT_DATE=`date '+%Y-%m-%d'`
CURRENT_TIME=` date '+%H-%M-%S'`
DATE_TIME=$CURRENT_DATE/$CURRENT_TIME;

DB_NAME="sso"
DB_USER="mysql"
DB_PASS="password"

CONTAINER_NAME="db_sso_web"

BACKUP_DIR="/backup"
LOCAL_DIR="/home/vm001labmu/backup/containers/sso"


# Run mongodump inside the MongoDB container
docker exec $CONTAINER_NAME bash -c "mkdir -p $BACKUP_DIR/$DATE_TIME && mysqldump -u $DB_USER -p$DB_PASS $DB_NAME > $BACKUP_DIR/$DATE_TIME/$DB_NAME.sql"

mkdir -p $LOCAL_DIR

# Copy the backup from the container to the host machine
docker cp $CONTAINER_NAME:$BACKUP_DIR $LOCAL_DIR

if [ $? -eq 0 ]; then
  echo "Backup on $DATE_TIME"
  echo "Backup completed and copied to: $LOCAL_DIR"
else
  echo "Backup failed or copy operation failed."
fi
