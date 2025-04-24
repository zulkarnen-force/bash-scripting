#!/bin/bash

# Default values
TARGET_DIR=""
INCLUDE_DIRS=""
EXCLUDE_DIRS=""
RCLONE_REMOTE="myremote"
REMOTE_FOLDER="structured-backup"
RETENTION_DAYS=7
LOG_FILE="/var/log/rclone_backup.log"
DATE=$(date '+%Y-%m-%d_%H-%M-%S')

# Parse CLI arguments
for arg in "$@"; do
    case $arg in
        --target=*)
            TARGET_DIR="${arg#*=}"
            ;;
        --includes=*)
            INCLUDE_DIRS="${arg#*=}"
            ;;
        --excludes=*)
            EXCLUDE_DIRS="${arg#*=}"
            ;;
        --remote=*)
            RCLONE_REMOTE="${arg#*=}"
            ;;
        --remote-folder=*)
            REMOTE_FOLDER="${arg#*=}"
            ;;
        --retention=*)
            RETENTION_DAYS="${arg#*=}"
            ;;
        --log-file=*)
            LOG_FILE="${arg#*=}"
            ;;
        *)
            echo "Unknown argument: $arg"
            exit 1
            ;;
    esac
done

# Validate required
if [[ -z "$TARGET_DIR" ]]; then
    echo "ERROR: --target is required"
    exit 1
fi

# Validate folder
if [[ ! -d "$TARGET_DIR" ]]; then
    echo "ERROR: Target directory '$TARGET_DIR' does not exist"
    exit 1
fi

# Convert comma-separated to include/exclude flags
RCLONE_FILTER_ARGS=""

if [[ -n "$INCLUDE_DIRS" ]]; then
    IFS=',' read -ra INCLUDES <<< "$INCLUDE_DIRS"
    for inc in "${INCLUDES[@]}"; do
        RCLONE_FILTER_ARGS+=" --include=/$inc/**"
    done
    RCLONE_FILTER_ARGS+=" --exclude=/**"  # exclude everything else
elif [[ -n "$EXCLUDE_DIRS" ]]; then
    IFS=',' read -ra EXCLUDES <<< "$EXCLUDE_DIRS"
    for exc in "${EXCLUDES[@]}"; do
        RCLONE_FILTER_ARGS+=" --exclude=/$exc/**"
    done
fi

REMOTE_PATH="$RCLONE_REMOTE:$REMOTE_FOLDER/$DATE"

# Log start
echo "[$(date)] Starting backup: $TARGET_DIR -> $REMOTE_PATH" | tee -a "$LOG_FILE"

# Run backup
eval rclone copy "\"$TARGET_DIR\"" "\"$REMOTE_PATH\"" \
    $RCLONE_FILTER_ARGS \
    --log-file="$LOG_FILE" \
    --log-level=INFO \
    --progress

# Log end
echo "[$(date)] Backup completed" | tee -a "$LOG_FILE"

# Retention cleanup (remote)
echo "[$(date)] Cleaning up old remote backups older than $RETENTION_DAYS days" | tee -a "$LOG_FILE"
rclone lsf "$RCLONE_REMOTE:$REMOTE_FOLDER/" --dirs-only | while read -r dir; do
    clean_date=$(echo "$dir" | sed 's|/$||')
    backup_time=$(date -d "$clean_date" +%s 2>/dev/null)
    [ -z "$backup_time" ] && continue
    current_time=$(date +%s)
    age_days=$(( (current_time - backup_time) / 86400 ))
    if [ "$age_days" -gt "$RETENTION_DAYS" ]; then
        echo "Deleting remote folder: $dir (Age: $age_days days)" | tee -a "$LOG_FILE"
        rclone purge "$RCLONE_REMOTE:$REMOTE_FOLDER/$dir"
    fi
done

# bash rclone-flexible-backup.sh \
#   --target=/home/zulkarnen \
#   --includes=Documents \
#   --remote=pcloud706 \
#   --remote-folder=zulk-backup \
#   --log-file=/var/log/rclone_backup.log
