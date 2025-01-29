#!/bin/bash

# Function to display usage
usage() {
    echo "Usage: $0 -d <backup_destination> -s <source_directory> [-e <exclude_file>] [-r <retain_number>]"
    echo "  -d, --destination   Backup destination directory (required)"
    echo "  -s, --source        Source directory to back up (required)"
    echo "  -e, --exclude       File containing list of folders to exclude (optional)"
    echo "  -r, --retain        Number of latest backups to retain (optional, default: 7)"
    exit 1
}

# Default retain number
RETAIN_NUMBER=7

# Parse command-line arguments
while getopts ":d:s:e:r:" opt; do
    case $opt in
        d) BACKUP_DIR="$OPTARG" ;;
        s) SOURCE_DIR="$OPTARG" ;;
        e) EXCLUDE_FILE="$OPTARG" ;;
        r) RETAIN_NUMBER="$OPTARG" ;;
        *) usage ;;
    esac
done

# Validate required arguments
if [[ -z "$BACKUP_DIR" || -z "$SOURCE_DIR" ]]; then
    echo "Error: Missing required arguments."
    usage
fi

# Validate retain number
if ! [[ "$RETAIN_NUMBER" =~ ^[0-9]+$ ]]; then
    echo "Error: Retain number must be a positive integer."
    usage
fi

# Variables
TIMESTAMP=$(date +"%Y%m%d-%H%M%S")   # Timestamp for the backup folder
BACKUP_PATH="$BACKUP_DIR/$TIMESTAMP" # Full path for the backup folder

START_TIME=$(date +%s)


# Create the backup directory with timestamp
mkdir -p "$BACKUP_PATH"

# Perform the backup using rsync
if [[ -n "$EXCLUDE_FILE" && -f "$EXCLUDE_FILE" ]]; then
    rsync -av --progress --exclude-from="$EXCLUDE_FILE" "$SOURCE_DIR" "$BACKUP_PATH"
else
    rsync -av --progress "$SOURCE_DIR" "$BACKUP_PATH"
fi

END_TIME=$(date +%s)
# Calculate duration
DURATION=$((END_TIME - START_TIME))

# Convert duration to hours, minutes, and seconds
HOURS=$((DURATION / 3600))
MINUTES=$(( (DURATION % 3600) / 60 ))
SECONDS=$((DURATION % 60))

# Retain only the latest backups
cd "$BACKUP_DIR" || exit
if [[ "$RETAIN_NUMBER" -gt 0 ]]; then
    ls -dt */ | tail -n +$(($RETAIN_NUMBER + 1)) | xargs rm -rf
fi

echo "Backup completed successfully to $BACKUP_PATH"
echo "Retaining the latest $RETAIN_NUMBER backups."
echo "Backup completed in $HOURS hours, $MINUTES minutes, and $SECONDS seconds."
