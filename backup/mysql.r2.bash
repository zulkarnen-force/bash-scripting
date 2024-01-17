#/bin/bash
USER_NAME=$(whoami)

OPTS=$(getopt -o d: -n "$0" -- "$@")
eval set -- "$OPTS"

usage() {
    echo "Usage: $0 [-d| <value>]"
    exit 1
}

while true; do
    case "$1" in
    -d)
        database=$2
        shift 2
        ;;
    *)
        break
        ;;
    esac
done


if [ -z "$database" ]; then
    usage
fi

CURRENT_DATE=`date '+%Y-%m-%d'`
CURRENT_TIME=`date '+%Y-%m-%d-%H-%M-%S'`
BACKUP_DIR="/home/$USER_NAME/backup/$database/$CURRENT_DATE/raw"

if [ ! -d "$BACKUP_DIR" ]; then
    echo "backup dir not found"
    echo "$BACKUP_DIR"
    exit
fi

COMPRESSED_DIR="/home/$USER_NAME/backup/$database/$CURRENT_DATE/compressed"
COMPRESSED_FILE="$COMPRESSED_DIR/$USER_NAME-$database-$CURRENT_TIME.tar.gz"
REMOTE_DIR="labmu:${USER_NAME}-$database"

if [ ! -d "$COMPRESSED_DIR" ]; then
    mkdir -p "$COMPRESSED_DIR"
fi

tar  -cvzf "$COMPRESSED_FILE" -C $BACKUP_DIR ./

echo "🔥 lsStart copying $COMPRESSED_FILE to $REMOTE_DIR 🔥"
rclone_output=$(rclone copy -P -vv "$COMPRESSED_FILE" "$REMOTE_DIR")
echo "🔥 Finished copying $COMPRESSED_FILE to $REMOTE_DIR 🔥"

if [ $? -eq 0 ]; then
    echo "Copy completed successfully"
    echo "Clean Up 🚀 folder raw and compressed"
    rm -rf "$BACKUP_DIR"
    rm -rf "$COMPRESSED_DIR"
    echo "Removed $COMPRESSED_FILE successfully."
else
    echo "Error: rclone copy failed. $COMPRESSED_FILE was not removed."
    echo "Command output: $rclone_output"
fi