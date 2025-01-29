#!/bin/bash

# Default values (can be overridden by arguments)
REMOTE_NAME="default"        # Default Rclone remote name
REMOTE_DIR="Backup"          # Default base destination folder
LOG_FILE="$HOME/backup.log"  # Default log file location
INCLUDE_FILE="$HOME/Developments/DevOps/bash-scripting/rclone/include.txt" # Default include file
RETENTION_COUNT=7            # Default number of backup folders to retain

# Function to display usage instructions
usage() {
    echo "Usage: $0 [OPTIONS] <operation>"
    echo "Options:"
    echo "  -r, --remote-name <name>      Rclone remote name"
    echo "  -d, --remote-dir <path>       Remote directory base path"
    echo "  -l, --log-file <path>         Log file location"
    echo "  -i, --include-file <path>     Include file path"
    echo "  -t, --retention-count <num>   Number of backup folders to retain"
    echo "Operation:"
    echo "  copy            Copy local files to remote"
    echo "  sync            Sync local files to remote"
    echo "  remote-sync     Sync remote files to local"
    echo "  delete-excluded Delete files in remote matching exclude patterns"
    exit 1
}

# Parse command-line arguments
while [[ "$#" -gt 0 ]]; do
    case "$1" in
        -r|--remote-name)
            REMOTE_NAME="$2"
            shift 2
            ;;
        -d|--remote-dir)
            REMOTE_DIR="$2"
            shift 2
            ;;
        -l|--log-file)
            LOG_FILE="$2"
            shift 2
            ;;
        -i|--include-file)
            INCLUDE_FILE="$2"
            shift 2
            ;;
        -t|--retention-count)
            RETENTION_COUNT="$2"
            shift 2
            ;;
        -h|--help)
            usage
            ;;
        *)
            OPERATION="$1"
            shift
            ;;
    esac
done

# Validate operation argument
if [ -z "$OPERATION" ]; then
    echo "Error: Operation is required."
    usage
fi

# Timestamp for log entries
TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")
# Datetime for backup folder naming
DATETIME=$(date +"%Y%m%d%H%M%S")
# Full remote backup path for this run
REMOTE_DIR_WITH_TIMESTAMP="$REMOTE_DIR/$DATETIME"

echo "[$TIMESTAMP] Starting backup process..." >> "$LOG_FILE"

case "$OPERATION" in
    copy)
        echo "[$TIMESTAMP] Starting initial copy of / to $REMOTE_NAME:$REMOTE_DIR/$(basename +"$folder")/$DATETIME..." >> "$LOG_FILE"
        while read -r folder; do
            rclone copy "$folder" "$REMOTE_NAME:$REMOTE_DIR/$(basename +"$folder")/$DATETIME" --progress --progress --log-file="$LOG_FILE" --log-level INFO 
        done < "$INCLUDE_FILE"
        ;;
    sync)
        echo "[$TIMESTAMP] Starting sync of / to $REMOTE_NAME:$REMOTE_DIR_WITH_TIMESTAMP..." >> "$LOG_FILE"
        rclone sync / "$REMOTE_NAME:$REMOTE_DIR_WITH_TIMESTAMP" --progress --log-file="$LOG_FILE" --log-level INFO \
        --include-from "$INCLUDE_FILE"
        ;;
    remote-sync)
        echo "[$TIMESTAMP] Starting sync from $REMOTE_NAME:$REMOTE_DIR to /..." >> "$LOG_FILE"
        rclone sync "$REMOTE_NAME:$REMOTE_DIR" / --progress --log-file="$LOG_FILE" --log-level INFO \
        --include-from "$INCLUDE_FILE"
        ;;
    delete-excluded)
        echo "[$TIMESTAMP] Deleting files from $REMOTE_NAME:$REMOTE_DIR matching exclude patterns..." >> "$LOG_FILE"
        rclone delete "$REMOTE_NAME:$REMOTE_DIR" --include-from "$INCLUDE_FILE" --log-file="$LOG_FILE" --log-level INFO
        ;;
    *)
        echo "Error: Invalid operation '$OPERATION'."
        usage
        ;;
esac

# Check if the command was successful
if [ $? -eq 0 ]; then
    echo "[$TIMESTAMP] Backup completed successfully to $REMOTE_NAME:$REMOTE_DIR_WITH_TIMESTAMP." >> "$LOG_FILE"
else
    echo "[$TIMESTAMP] Backup failed. Check the log for details." >> "$LOG_FILE"
    exit 1
fi

echo "[$TIMESTAMP] Enforcing retention policy: keeping only the latest $RETENTION_COUNT backups for each folder..." >> "$LOG_FILE"

while read -r folder; do
    # Skip empty lines or commented lines
    [[ -z "$folder" || "$folder" =~ ^# ]] && continue

    # Get the remote backup path for this folder
    BASE_FOLDER="$REMOTE_NAME:$REMOTE_DIR/$(basename "$folder")"

    echo "[$TIMESTAMP] Checking backups in $BASE_FOLDER..." >> "$LOG_FILE"

    # List all backup subfolders (timestamps), sort in reverse order (newest first)
    BACKUP_FOLDERS=$(rclone lsf "$BASE_FOLDER" --dirs-only --log-file="$LOG_FILE" --log-level INFO | sort -r)

    COUNT=0
    while read -r BACKUP; do
        COUNT=$((COUNT + 1))
        if [ "$COUNT" -gt "$RETENTION_COUNT" ]; then
            OLD_BACKUP="$BASE_FOLDER/$BACKUP"
            echo "[$TIMESTAMP] Deleting old backup: $OLD_BACKUP" >> "$LOG_FILE"
            rclone purge "$OLD_BACKUP" --log-file="$LOG_FILE" --log-level INFO
        fi
    done <<< "$BACKUP_FOLDERS"

done < "$INCLUDE_FILE"

echo "[$TIMESTAMP] Retention policy enforcement completed." >> "$LOG_FILE"

