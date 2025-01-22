#!/bin/bash
OPTS=$(getopt -o c:d:u:p:t: -n "$0" -- "$@")
eval set -- "$OPTS"

# Rclone remote name and destination directory
RCLONE_REMOTE="mega"

usage() {
    echo
    echo "Usage: "
    echo "     $0 [-c <container>] [-d <database>] [-u <user>] [-p <password>] [-t <type>]"
    echo "Export the contents of a database in a container."
    echo "Options: "
    echo "  -c     Container name."
    echo "  -d     Database name."
    echo "  -u     User for authentication."
    echo "  -p     Password for user."
    echo "  -t     Type of database: [mongo|mysql|postgres]."
    echo
    exit 1
}

log() {
    local message="$1"
    echo "$(date +'%Y-%m-%d %H:%M:%S') - $message" >> "$error_log"
}

# Parse arguments
while true; do
    case $1 in 
        -c) container=$2; shift 2 ;;
        -d) database=$2; shift 2 ;;
        -u) user=$2; shift 2 ;;
        -p) password=$2; shift 2 ;;
        -t) type=$2; shift 2 ;;
        *) break ;;
    esac
done

if [ -z "$container" ] || [ -z "$database" ] || [ -z "$user" ] || [ -z "$password" ] || [ -z "$type" ]; then
    usage
fi

username=$(whoami)
current_date=$(date '+%Y%m%d')
current_time=$(date '+%Y%m%d%H%M%S')
backup_dir="/home/$username/backup/$database/$current_date/$current_time"
error_log="/home/$username/backup/$database/dump.log"
REMOTE_DIR="backup/${username}"
mkdir -p "$backup_dir"

backup_success() {
    log "Backup database $type completed successfully. Check ${backup_dir} for details."
    echo "Backup completed successfully. Check ${backup_dir} for details."
}

backup_failure() {
    log "Backup failed. Check ${error_log} for details."
    echo "Backup failed. Check ${error_log} for details."
}

cleanup_old_backups() {
    local backup_base_dir="/home/$username/backup/$database"
    
    old_backups=$(ls -dt "${backup_base_dir}"/* | tail -n +4)
    for dir in $old_backups; do
        rm -rf "$dir"
        log "Deleted old backup directory: $dir"
    done
}

if [ "$type" = "mongo" ]; then
    MONGO_SCRIPT="mongodump --db $database --gzip --out /backup"
    log "Starting MongoDB backup..."
    docker exec "$container" bash -c "$MONGO_SCRIPT" > "$error_log" 2>&1
    if [ $? -eq 0 ]; then
        docker cp "$container:/backup/$database/." "$backup_dir"
        backup_success
    else
        backup_failure
    fi
elif [ "$type" = "mysql" ]; then
    log "Starting MySQL backup..."
    mkdir -p "$backup_dir"
    docker exec "$container" mysqldump -u"$user" -p"$password" "$database" > "${backup_dir}/${database}-$current_time.sql"
    if [ $? -eq 0 ]; then
        backup_success
    else
        backup_failure
    fi
elif [ "$type" = "postgres" ]; then
    log "Starting PostgreSQL backup..."
    mkdir -p "$backup_dir"
    PGPASSWORD="$password" docker exec "$container" pg_dump -U "$user" -d "$database" -F c -b -v -f /"$database-$current_time".dump
    if [ $? -eq 0 ]; then
        docker cp "$container:/"$database-$current_time".dump" "$backup_dir"
        backup_success
    else
        backup_failure
    fi
else
    log "Unsupported database type: $type"
    echo "Unsupported database type: $type"
    usage
fi

zip_file="${backup_dir}.zip"
log "Compressing backup directory to ${zip_file}..."
(cd "$backup_dir" && zip -r "$zip_file" .) >> "$error_log" 2>&1
if [ $? -ne 0 ]; then
    log "Failed to compress backup directory."
    echo "Failed to compress backup directory. Check ${error_log} for details."
    exit 1
fi

log "Syncing compressed backup to remote with rclone..."
rclone copy "$zip_file" "$RCLONE_REMOTE:$REMOTE_DIR/$database/$current_date" >> "$error_log" 2>&1
if [ $? -eq 0 ]; then
    log "Backup successfully synced to remote."
    echo "Backup successfully synced to remote."
else
    log "Failed to sync backup to remote. Check ${error_log} for details."
    echo "Failed to sync backup to remote. Check ${error_log} for details."
    exit 1
fi

log "Cleaning up local backup files..."
rm -rf "$backup_dir"
if [ $? -eq 0 ]; then
    log "Cleanup completed successfully."
    echo "Cleanup completed successfully."
else
    log "Failed to clean up backup files."
    echo "Failed to clean up backup files. Check ${error_log} for details."
fi

cleanup_old_backups


# ./backup.database.container.sh -u mysql -p password -d sotabar -c db.sotabar -t mysql
# ./backup.database.container.sh -u helpdesk_dev -p HelpDesk1! -d helpdesk_uat -c helpme.db -t postgres
# ./backup.database.container.sh -u helpdesk_dev -p HelpDesk1! -d helpdesk_dev -c db.admin -t mongo