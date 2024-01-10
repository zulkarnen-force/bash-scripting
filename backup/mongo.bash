#!/usr/bin/env bash

MONGO_URL="mongodb://root:supersecret@localhost:27017/$1?authSource=admin"
CONTAINER_NAME="$2"
BACKUP_PARENT_DIR="/tmp/$2"
BACKUP_DIR="$2-`date +%Y-%m-%d-%H-%M-%S`"

if [ -z "$1" ]; then
    echo "Database name  is on first argument on command linee"
    exit
fi

if [ -z "$CONTAINER_NAME" ]; then
    echo "Container name is required second argument on command line"
    exit
fi

    
mkdir -p "$BACKUP_PARENT_DIR"
echo "##################################"
echo "Backup will start at '`date`' for database: '$MONGO_URL'"
echo "##################################"
# docker run --rm -it -v "$BACKUP_PARENT_DIR:/backup" mongo:3.4 mongodump --uri="$MONGO_URL"  --gzip --out "/home/zulkarnen/backup/$BACKUP_DIR"
docker exec -it $CONTAINER_NAME bash -c "mongodump --uri=$MONGO_URL --gzip --archive=/backup/$BACKUP_DIR"
echo "##################################"
echo "Backup completed at '`date`' to '$BACKUP_PARENT_DIR/$BACKUP_DIR'"
echo "##################################"
docker cp $CONTAINER_NAME:/backup/$BACKUP_DIR ./
