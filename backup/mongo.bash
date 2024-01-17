#!/bin/bash

MONGO_URL="mongodb://root:supersecret@localhost:27017/$1?authSource=admin"
CONTAINER_NAME="$2"
HOST_BACKUP_DIR="/home/$USER/backup/$2"
BACKUP_DIR="$2-`date +%Y-%m-%d-%H-%M-%S`"
CONTAINER_BACKUP_DIR="/backup"

if [ -z "$1" ]; then
    echo "Database name is on first argument on command line"
    exit
fi

if [ -z "$CONTAINER_NAME" ]; then
    echo "Container name is required second argument on command line"
    exit
fi

mkdir -p "$HOST_BACKUP_DIR"
mkdir -p $HOST_BACKUP_DIR/compressed/
echo "##################################"
echo "Backup will start at '`date`' for database: '$MONGO_URL'"
echo "##################################"
docker exec -it $CONTAINER_NAME bash -c "mongodump --uri=$MONGO_URL --gzip -o $CONTAINER_BACKUP_DIR/$BACKUP_DIR"
echo "##################################"
echo "Backup completed at '`date`' to '$HOST_BACKUP_DIR/$BACKUP_DIR'"
echo "##################################"
docker cp "$CONTAINER_NAME:$CONTAINER_BACKUP_DIR/$BACKUP_DIR" "$HOST_BACKUP_DIR"
tar -zcvf $HOST_BACKUP_DIR/compressed/$BACKUP_DIR.tar.gz -C $HOST_BACKUP_DIR "$BACKUP_DIR/"


# remove temp file
rm -rf $HOST_BACKUP_DIR/$BACKUP_DIR
docker exec -it $CONTAINER_NAME bash -c "rm -rf $CONTAINER_BACKUP_DIR/$BACKUP_DIR"