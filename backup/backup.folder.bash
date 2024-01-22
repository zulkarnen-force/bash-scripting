#!/bin/bash

# Function to display usage information
usage() {
    echo "Usage: $0 -d|--dir <directory> -p|--project <project>"
    echo "Options:"
    echo "  -d, --dir      Specify the directory to be archived"
    echo "  -p, --project  Specify the project name"
    echo "  -h, --help     Display this help message"
    exit 1
}

# Function to check if the project name is valid
is_valid_project() {
    [[ "$1" =~ ^[a-zA-Z-]+$ ]]
}

# Parse command line options
while [[ "$#" -gt 0 ]]; do
    case "$1" in
        -d|--dir)
            directory="$2"
            shift 2 ;;
        -p|--project)
            project="$2"
            shift 2 ;;
        -h|--help)
            usage ;;
        *)
            usage ;;
    esac
done

# Check if help is requested
if [ -z "$directory" ] || [ -z "$project" ]; then
    usage
fi

# Check if the directory exists
if [ ! -d "$directory" ]; then
    echo "Error: Directory does not exist: $directory"
    exit 1
fi

# Check if the project name is valid
if ! is_valid_project "$project"; then
    echo "Error: Invalid project name. Allowed characters: a-z, A-Z, -"
    exit 1
fi


username=$(whoami)
temp_dir="/home/$username/backup/temp"
mkdir -p "$temp_dir"
# Create a timestamp for the tar.gz file
timestamp=$(date +"%Y%m%d_%H%M%S")

# Create tar.gz archive with project name in the filename
tar_filename="${project}_$timestamp.tar.gz"
tar -czvf "${temp_dir}/${tar_filename}" -C "$(dirname "$directory")" "$(basename "$directory")"
# tar -czvf "${tar_filename}" -C "$(dirname "$directory")" "$(basename "$directory")"

# Specify the rclone remote and destination path
rclone_remote="labmu"
destination_path="${username}-$project"
echo "🚑 ✨ Copy "${temp_dir}/${tar_filename}" to $rclone_remote:$destination_path 🚚"
echo "🔇...."
echo "🔇..."
echo "🔇.."
echo "🔇."
# Copy the tar.gz file to rclone remote
rclone_status=$(rclone copy "${temp_dir}/${tar_filename}" "${rclone_remote}:${destination_path}")

echo "🏗  Finish copying "${temp_dir}/${tar_filename}" to $rclone_remote:$destination_path 💥"

# Optionally, remove the local tar.gz file after copying
# Uncomment the next line if you want t o remove the local file

if [ $? -eq 0 ]; then
    echo "📦  Remove temp file on "${temp_dir}/${tar_filename}"" 
    rm ""${temp_dir}/${tar_filename}""
    echo "Clean up remote file ${rclone_remote}:${destination_path} --min-age 3d"
    rclone delete "${rclone_remote}:${destination_path}" --min-age 3d
    echo "Backup completed and copied to remote successfully."  
else 
     echo "Error: rclone copy failed. "${temp_dir}/${tar_filename}" was not removed."
    echo "Command output: $rclone_status"
fi



