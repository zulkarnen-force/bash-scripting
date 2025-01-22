#!/bin/bash
SOURCE_DIR="$HOME"           # Source directory
REMOTE_NAME="pcloud706"                    # Replace with your Rclone remote name for Mega
REMOTE_DIR="Linux/home"           # Destination folder on Mega
LOG_FILE="$HOME/backup.log"             # Log file location
EXCLUDE_FILE="$HOME/Developments/DevOps/bash-scripting/rclone/exclude_pcloud706.txt"        # Path to your exclude file
INCLUDE_FILE="$HOME/Developments/DevOps/bash-scripting/rclone/pcloud706.txt"        # Path to your exclude file

# Timestamp for log entries
TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")
echo "[$TIMESTAMP] Starting backup process..." >> $LOG_FILE
# Check if an argument was provided (copy, sync, remote-sync, or delete-excluded)
if [ -z "$1" ]; then
    echo "No argument provided. Defaulting to 'copy' operation."
    set -- copy  # Set the default option to 'copy'
fi

case "$1" in
    copy)
        echo "[$TIMESTAMP] Starting initial copy of $SOURCE_DIR to Mega..." >> $LOG_FILE
        rclone copy "$SOURCE_DIR" "$REMOTE_NAME:$REMOTE_DIR" --progress --log-file="$LOG_FILE" --log-level INFO \
        --include-from "$INCLUDE_FILE" --exclude-from "$EXCLUDE_FILE"
        ;;
    sync)
        echo "[$TIMESTAMP] Starting sync of $SOURCE_DIR to Mega..." >> $LOG_FILE
        rclone sync "$SOURCE_DIR" "$REMOTE_NAME:$REMOTE_DIR" --progress --log-file="$LOG_FILE" --log-level INFO \
         --include-from "$INCLUDE_FILE"
        ;;
    remote-sync)
        echo "[$TIMESTAMP] Starting sync from Mega to $SOURCE_DIR..." >> $LOG_FILE
        rclone sync "$REMOTE_NAME:$REMOTE_DIR" "$SOURCE_DIR" --progress --log-file="$LOG_FILE" --log-level INFO \
          --include-from "$INCLUDE_FILE"
        ;;
    delete-excluded)
        echo "[$TIMESTAMP] Deleting files from remote matching exclude patterns..." >> $LOG_FILE
        rclone delete "$REMOTE_NAME:$REMOTE_DIR" --include-from "$INCLUDE_FILE" --log-file="$LOG_FILE" --log-level INFO
        ;;
    *)
        echo "Invalid option. Use 'copy' for initial backup, 'sync' for subsequent syncs, 'remote-sync' for syncing from remote to local, or 'delete-excluded' to delete files from remote matching exclude patterns."
        exit 1
        ;;
esac

# Check if the command was successful
if [ $? -eq 0 ]; then
    echo "[$TIMESTAMP] Backup completed successfully." >> $LOG_FILE
else
    echo "[$TIMESTAMP] Backup failed. Check the log for details." >> $LOG_FILE
fi
