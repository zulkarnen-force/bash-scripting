#!/bin/bash

# Parse options using getopt
OPTS=$(getopt -o c:d:u:p:t:h: -n "$0" -- "$@")
if [ $? != 0 ] ; then usage; exit 1 ; fi
eval set -- "$OPTS"

# Function to display usage information
usage() {
   echo
   echo "Usage: "
   echo "     $0 [-c <container>] [-d <database>] [-u <user>] [-p <password>] [-t <type>] [-h <host>]"
   echo
   echo "Export the contents of a database in a container."
   echo
   echo "Options: "
   echo "  -c     Container name."
   echo "  -d     Database name."
   echo "  -u     User authenticated."
   echo "  -p     Password for user authenticated."
   echo "  -t     Type of database: [mongo|mysql|postgres]."
   echo "  -h     Host (optional for postgres)."
   echo
   echo "See https://git.muhammadiyah.or.id/labmu-developer-team/research-ci-cd/-/wikis/Home-Page for more information."
   echo
   exit 1
}

# Check if Docker is installed and running
if ! command -v docker &> /dev/null; then
    echo "Error: Docker is not installed or not in the PATH."
    exit 1
fi

if ! docker info &> /dev/null; then
    echo "Error: Docker is not running. Please start Docker and try again."
    exit 1
fi



# Parse command-line options
while true; do
    case "$1" in 
    -c) 
        container="$2"
        shift 2
        ;;
    -d) 
        database="$2"
        shift 2
        ;;
    -u) 
        user="$2"
        shift 2
        ;;
    -p) 
        password="$2"
        shift 2
        ;;
    -t) 
        type="$2"
        shift 2
        ;;
    -h) 
        host="$2"
        shift 2
        ;;
    --) 
        shift
        break
        ;;
    *) 
        usage
        ;;
    esac
done

destination_path="${username}-db-${database}"

# Validate required options
if [ -z "$container" ] || [ -z "$database" ] || [ -z "$user" ] || [ -z "$password" ] || [ -z "$type" ]; then
    usage
fi

USER_NAME=$(whoami)
CURRENT_DATE=$(date '+%Y-%m-%d')
CURRENT_TIME=$(date '+%Y-%m-%d-%H-%M-%S')
BACKUP_DIR="/home/$USER_NAME/backup/$database/$CURRENT_DATE/raw"
LOG_DIR="/home/$USER_NAME/backup/$database/$CURRENT_DATE/logs"
mkdir -p "$BACKUP_DIR/$CURRENT_TIME" "$LOG_DIR"

error_log="${LOG_DIR}/dump_$CURRENT_TIME.log"

# Backup the database based on type
case "$type" in
    mongo)
        MONGO_SCRIPT="mongodump --username $user --password $password --authenticationDatabase=admin --db $database --gzip --out /backup"
        docker exec "$container" bash -c "$MONGO_SCRIPT" > "$error_log" 2>&1
        if [ $? -eq 0 ]; then
            docker cp "$container:/backup/$database/." "$BACKUP_DIR/$CURRENT_TIME"
            echo "Backup of MongoDB database '$database' completed successfully."
        else
            echo "MongoDB backup failed. Check ${error_log} for details."
        fi
        ;;
    mysql)
        docker exec "$container" mysqldump -u"$user" -p"$password" "$database" > "${BACKUP_DIR}/${database}-${CURRENT_TIME}.sql" 2> "$error_log"
        if [ $? -eq 0 ]; then
            echo "Backup of MySQL database '$database' completed successfully."
            gzip "${BACKUP_DIR}/${database}-${CURRENT_TIME}.sql"
        else
            echo "MySQL backup failed. Check ${error_log} for details."
        fi
        ;;
    postgres)
        if [ -z "$host" ]; then
            host="localhost"
        fi
        POSTGRES_SCRIPT="PGPASSWORD=$password pg_dump -h $host -U $user $database"
        docker exec "$container" sh -c "$POSTGRES_SCRIPT" > "${BACKUP_DIR}/${database}-${CURRENT_TIME}.sql" 2> "$error_log"
        if [ $? -eq 0 ]; then
            echo "Backup of PostgreSQL database '$database' completed successfully."
        else
            echo "PostgreSQL backup failed. Check ${error_log} for details."
        fi
        ;;
    *)
        echo "Unsupported database type: $type"
        usage
        ;;
esac

# Log completion
echo "Backup process completed. Backup files are located in ${BACKUP_DIR}."

# Upload to R2 using rclone
RCLONE_REMOTE="labmu" # Replace with your R2 remote name in rclone configuration
RCLONE_DESTINATION="${CURRENT_DATE}" # Replace with your R2 destination path

# Check if rclone is installed
if ! command -v rclone &> /dev/null; then
    echo "Error: rclone is not installed or not in the PATH."
    exit 1
fi


echo "Uploading backup to R2 using rclone..."
rclone copy "$BACKUP_DIR/$CURRENT_TIME" "$RCLONE_REMOTE:$destination_path:$RCLONE_DESTINATION" --log-file "$LOG_DIR/rclone_$CURRENT_TIME.log" --log-level INFO

echo "Backup successfully uploaded to R2 in $BACKUP_DIR/$CURRENT_TIME" "$RCLONE_REMOTE:$destination_path:$RCLONE_DESTINATION"

# Clean up temporary files and old backups
# if $dry_run; then
#     log "[DRY-RUN] Would remove temporary archive: ${temp_dir}/${tar_filename}"
#     log "[DRY-RUN] Would clean up old files on remote: ${rclone_remote}:${destination_path} --min-age 3d"
# else
#     log "Start to removing temporary archive: ${temp_dir}/${tar_filename}"
#     if [ $? -eq 0 ]; then
#         log "Removing temporary archive: ${temp_dir}/${tar_filename}"
#         rm -f "${temp_dir}/${tar_filename}"
#         log "Cleaning up old files on remote"
#         rclone delete "${rclone_remote}:${destination_path}" --min-age 3d
#     else
#         log "Error: rclone copy failed. Archive not removed."
#         log "Command output: $rclone_status"
#         exit 1
#     fi
# fi

if [ $? -eq 0 ]; then
    echo "Backup successfully uploaded to R2."
else
    echo "Failed to upload backup to R2. Check the log for details: $LOG_DIR/rclone_$CURRENT_TIME.log"
fi
