#/bin/bash
USER_NAME=$(whoami)

OPTS=$(getopt -o f:p: -n "$0" -- "$@")
eval set -- "$OPTS"

delete_old_backup() {
     remote_dir=$1 
     if [ -z "$remote_dir" ]; then
         echo "Error: Remote directory not specified."
         exit 1
     fi
     echo "Deleting old backup files..."
     rclone delete "$remote_dir" --min-age 3d
}

usage() {
    echo "Usage: $0 [-f <value>] [-p <value>]"
    exit 1
}

while true; do
    case "$1" in
    -f)
        folder=$2
        shift 2
        ;;
    -p)
        project=$2
        shift 2
        ;;
    *)
        break
        ;;
    esac
done

if [ -z "$folder"  ]; then
    usage
fi

if [ -z "$project"  ]; then
    usage
fi


CURRENT_TIME=`date '+%Y%m%d%H%M%S'`
COMPRESSED_DIR="/tmp/backup/$project/compressed"
COMPRESSED_FILE="$COMPRESSED_DIR/$USER_NAME-$project-$CURRENT_TIME.tar.gz"
remote_dir="labmu:${USER_NAME}-$project"

if [ ! -d "$COMPRESSED_DIR" ]; then
    mkdir -p "$COMPRESSED_DIR"
fi

tar -cvzf "$COMPRESSED_FILE" -C $folder ./

rclone_output=$(rclone copy -P -vv "$COMPRESSED_FILE" "$remote_dir")

if [ $? -eq 0 ]; then
    rclone delete "$REMOTE_DIR" --min-age 3d
    rm -rf "$BACKUP_DIR"
    rm -rf "$COMPRESSED_DIR"
else
    echo "Error: rclone copy failed. $COMPRESSED_FILE was not removed."
    echo "Command output: $rclone_output"
fi
