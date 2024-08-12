#!/bin/bash

# Exit immediately on errors or unset variables
set -euo pipefail

# Functions
usage() {
    echo "Usage: $0 -d|--dir <directory> -p|--project <project>"
    echo "Options:"
    echo "  -d, --dir      Specify the directory to be archived"
    echo "  -p, --project  Specify the project name"
    echo "  -h, --help     Display this help message"
    echo "  --dry-run      Perform a trial run with no changes made"
    exit 1
}

is_valid_project() {
    [[ "$1" =~ ^[a-zA-Z-]+$ ]]
}

check_dependencies() {
    for cmd in rclone tar; do
        if ! command -v "$cmd" &> /dev/null; then
            echo "Error: Required command '$cmd' is not installed." >&2
            exit 1
        fi
    done
}

log() {
    echo "$(date +'%Y-%m-%d %H:%M:%S') - $1"
}

# Default to non-dry-run mode
dry_run=false

# Parse command-line arguments
while [[ "$#" -gt 0 ]]; do
    case "$1" in
        -d|--dir)
            directory="$2"
            shift 2 ;;
        -p|--project)
            project="$2"
            shift 2 ;;
        --dry-run)
            dry_run=true
            shift ;;
        -h|--help)
            usage ;;
        *)
            usage ;;
    esac
done

# Set variables
rclone_remote="labmu"
username=$(whoami)
temp_dir="/home/$username/backup/temp"
timestamp=$(date +"%Y%m%d_%H%M%S")
tar_filename="${project}_${timestamp}.tar.gz"
destination_path="${username}-${project}"

# Validate inputs
if [ -z "${directory-}" ] || [ -z "${project-}" ]; then
    usage
fi

# Check if the directory exists
if [ ! -d "$directory" ]; then
    echo "Error: Directory does not exist: $directory" >&2
    exit 1
fi

# Validate project name
if ! is_valid_project "$project"; then
    echo "Error: Invalid project name. Allowed characters: a-z, A-Z, -" >&2
    exit 1
fi

# Check for required dependencies
check_dependencies

# Ensure temporary directory exists
mkdir -p "$temp_dir"

# Create the archive
log "Creating archive for $directory"
if $dry_run; then
    log "[DRY-RUN] Would create archive: ${temp_dir}/${tar_filename}"
else
    tar -czvf "${temp_dir}/${tar_filename}" -C "$(dirname "$directory")" "$(basename "$directory")"
fi

# Copy archive to remote
log "Copying archive to $rclone_remote:$destination_path"
if $dry_run; then
    log "[DRY-RUN] Would copy ${temp_dir}/${tar_filename} to $rclone_remote:$destination_path"
else
    rclone_status=$(rclone copy "${temp_dir}/${tar_filename}" "${rclone_remote}:${destination_path}")
fi

# Clean up temporary files and old backups
if $dry_run; then
    log "[DRY-RUN] Would remove temporary archive: ${temp_dir}/${tar_filename}"
    log "[DRY-RUN] Would clean up old files on remote: ${rclone_remote}:${destination_path} --min-age 3d"
else
    log "Start to removing temporary archive: ${temp_dir}/${tar_filename}"
    if [ $? -eq 0 ]; then
        log "Removing temporary archive: ${temp_dir}/${tar_filename}"
        rm -f "${temp_dir}/${tar_filename}"
        log "Cleaning up old files on remote"
        rclone delete "${rclone_remote}:${destination_path}" --min-age 3d
    else
        log "Error: rclone copy failed. Archive not removed."
        log "Command output: $rclone_status"
        exit 1
    fi
fi

log "Backup process completed successfully."

