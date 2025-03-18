#!/bin/bash

# Ensure the script exits on error
set -e

# Function to display usage
usage() {
    echo "Usage: $0 -r <REMOTE_NAME> -s <SOURCE_FOLDER> -n <BACKUP_NAME> -t <RETENTION>"
    echo "  -r   Remote storage name (rclone configured remote)"
    echo "  -s   Source folder to backup"
    echo "  -n   Backup name (e.g., my-app-storage-backup)"
    echo "  -t   Number of backups to retain (retention policy)"
    exit 1
}

# Parse arguments
while getopts "r:s:n:t:" opt; do
  case ${opt} in
    r ) REMOTE_NAME=$OPTARG ;;
    s ) SOURCE_FOLDER=$OPTARG ;;
    n ) BACKUP_NAME=$OPTARG ;;
    t ) RETENTION=$OPTARG ;;
    * ) usage ;;
  esac
done

# Validate required arguments
if [[ -z "$REMOTE_NAME" || -z "$SOURCE_FOLDER" || -z "$BACKUP_NAME" || -z "$RETENTION" ]]; then
    usage
fi

# Ensure source folder exists
if [[ ! -d "$SOURCE_FOLDER" ]]; then
    echo "Error: Source folder '$SOURCE_FOLDER' does not exist."
    exit 1
fi

# Backup directory structure in remote storage
BACKUP_ROOT="backups/${BACKUP_NAME}"

# Timestamp for backup folder
TIMESTAMP=$(date +"%Y%m%d-%H%M%S")
BACKUP_FOLDER="${BACKUP_ROOT}/${TIMESTAMP}"

# Log file location
LOG_FILE="/var/log/backup.log"

echo "[$(date)] Starting backup to $REMOTE_NAME:$BACKUP_FOLDER ..." | tee -a "$LOG_FILE"

# Perform backup using rclone
rclone copy "$SOURCE_FOLDER" "$REMOTE_NAME:$BACKUP_FOLDER" --log-file="$LOG_FILE"

# Retention Policy: Keep only the latest N backups
echo "[$(date)] Applying retention policy for $BACKUP_NAME (keeping last $RETENTION backups)..." | tee -a "$LOG_FILE"
BACKUP_LIST=$(rclone lsf "$REMOTE_NAME:$BACKUP_ROOT" | sort -r | tail -n +$(($RETENTION + 1)))

for OLD_BACKUP in $BACKUP_LIST; do
    echo "[$(date)] Removing old backup: $OLD_BACKUP" | tee -a "$LOG_FILE"
    rclone purge "$REMOTE_NAME:$BACKUP_ROOT/$OLD_BACKUP"
done

echo "[$(date)] Backup completed successfully." | tee -a "$LOG_FILE"
