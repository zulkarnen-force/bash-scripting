#!/bin/bash

# Default values (can be overridden by arguments)
REMOTE_NAME="default"        # Default Rclone remote name
REMOTE_DIR="Backup"          # Default base destination folder
LOG_FILE="$HOME/backup.log"  # Default log file location
INCLUDE_FILE="$HOME/Developments/DevOps/bash-scripting/rclone/include.txt" # Default include file
RETENTION_COUNT=7            # Default number of backup folders to retain
SINGLE_FOLDER=""             # Store single folder path if provided

# Function to display usage instructions
usage() {
    echo "Usage: $0 [OPTIONS] <operation>"
    echo "Options:"
    echo "  -r, --remote-name <name>      Rclone remote name"
    echo "  -d, --remote-dir <path>       Remote directory base path"
    echo "  -l, --log-file <path>         Log file location"
    echo "  -i, --include-file <path>     Include file path"
    echo "  -t, --retention-count <num>   Number of backup folders to retain"
    echo "  -f, --folder <path>           Single folder to backup"
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
        -f|--folder)
            SINGLE_FOLDER="$2"
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
DATETIME=$(date +"%Y%m%d%H%M%S")

echo "[$TIMESTAMP] Starting backup process..." >> "$LOG_FILE"

# If a single folder is provided, use it instead of the include file
if [ -n "$SINGLE_FOLDER" ]; then
    FOLDERS=("$SINGLE_FOLDER")
else
    mapfile -t FOLDERS < "$INCLUDE_FILE"
fi

case "$OPERATION" in
    copy)
        for folder in "${FOLDERS[@]}"; do
            REMOTE_PATH="$REMOTE_DIR/$(basename "$folder")/$DATETIME"
            echo "[$TIMESTAMP] Copying $folder to $REMOTE_NAME:$REMOTE_PATH..." >> "$LOG_FILE"
            rclone copy "$folder" "$REMOTE_NAME:$REMOTE_PATH" --progress --log-file="$LOG_FILE" --log-level INFO
        done
        ;;
    sync)
        for folder in "${FOLDERS[@]}"; do
            REMOTE_PATH="$REMOTE_DIR/Sync/$(basename "$folder")"
            echo "[$TIMESTAMP] Syncing $folder to $REMOTE_NAME:$REMOTE_PATH..." >> "$LOG_FILE"
            rclone sync "$folder" "$REMOTE_NAME:$REMOTE_PATH" --progress --log-file="$LOG_FILE" --log-level INFO
        done
        ;;
    *)
        echo "Error: Invalid operation '$OPERATION'."
        usage
        ;;
esac

echo "[$TIMESTAMP] Backup completed." >> "$LOG_FILE"
