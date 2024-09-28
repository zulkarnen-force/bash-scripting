#!/bin/bash

# Parse options using getopt
# OPTS=$(getopt -o c:d:u:p:t:h:n: -n "$0" -- "$@")
# if [ $? != 0 ] ; then usage; exit 1 ; fi
# eval set -- "$OPTS"
set -euo pipefail

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

log() {
    echo "$(date +'%Y-%m-%d %H:%M:%S') - $1"
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
dry_run=false


# Parse command-line options
while [[ "$#" -gt 0 ]]; do
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
     -n) 
        project_name="$2"
        shift 2
        ;;
    --dry-run)
        dry_run=true
        shift ;;
    --) 
        shift
        break
        ;;
    *) 
        usage
        ;;
    esac
done
echo "dry_run: $dry_run"
host="localhost"
username=$(whoami)
destination_path="${username}-db-${database}"
# Validate required options
if [ -z "$container" ] || [ -z "$database" ] || [ -z "$user" ] || [ -z "$password" ] || [ -z "$type" ]  || [ -z "$project_name" ]; then
    usage
fi
username=$(whoami)
current_date=$(date '+%Y%m%d')
current_time=$(date '+%Y%m%d%H%M%S')
backup_dir_local="/home/$username/backup/$project_name/$current_date"
log_dir="/home/$username/backup/$project_name/$current_date"
mkdir -p "$backup_dir_local" "$log_dir"
rclone_remote="labmu"

echo "Starting backup of $type database $database in container $container..."
echo $destination_path
error_log="${log_dir}/${database}-${current_time}.log"
echo $current_date
echo "backup_dir_local: $backup_dir_local"
echo "LOGDIR: $log_dir"
echo "ERRORLOG: $error_log"
echo "CONTAINER: $container"
echo "DATABASE: $database"
echo "USER: $user"
echo "PASSWORD: $password"
echo "TYPE: $type"
echo "PROJECT_NAME: $project_name"
echo "RCLONE_REMOTE: $rclone_remote"

filename=""
backup_dir_with_filename=""
case "$type" in
    postgres)
        if [ -z "$host" ]; then
            host="localhost"
        fi
        POSTGRES_SCRIPT="PGPASSWORD=$password pg_dump -h $host -U $user $database"
        filename="${project_name}-${current_time}.sql"
        backup_dir_with_filename="${backup_dir_local}/${filename}"
        docker exec "$container" sh -c "$POSTGRES_SCRIPT" > "${backup_dir_with_filename}" 2> "$error_log"
        # tar -czf "${backup_dir_with_filename}.tar.gz" "${backup_dir_with_filename}.gz"
        if [ $? -eq 0 ]; then
            echo "Backup of PostgreSQL database '$database' completed successfully."
            echo "Backup file dir: ${backup_dir_with_filename}"
            echo "Backup filename: ${filename}"
        else
            echo "PostgreSQL backup failed. Check ${error_log} for details."
        fi
        ;;
    *)
        echo "Unsupported database type: $type"
        usage
        ;;
esac

target="${rclone_remote}:${username}/${project_name}/db"

# Copy archive to remote
# log "Copying archive to $rclone_remote:$destination_path"
if $dry_run; then
    log "[DRY-RUN] Would copy $backup_dir_with_filename to $target"
else
    echo "copying $backup_dir_with_filename to $target"
    rclone_status=$(rclone copy "$backup_dir_with_filename" "$target")
fi



# Clean up temporary files and old backups
if $dry_run; then
    log "[DRY-RUN] Would remove temporary archive: ${backup_dir_with_filename}"
    log "[DRY-RUN] Would clean up old files on remote: ${target} --min-age 3d"
else
    log "Start to removing temporary archive: ${backup_dir_with_filename}"
    if [ $? -eq 0 ]; then
        # log "Removing temporary archive: ${backup_dir_with_filename}"
        # rm -f "${backup_dir_with_filename}"
        # log "Cleaning up old files on remote"
        echo "rclone tree $target"
        # rclone delete "${rclone_remote}:${destination_path}" --min-age 3d
    else
        log "Error: rclone copy failed. Archive not removed."
        log "Command output: $rclone_status"
        exit 1
    fi
fi