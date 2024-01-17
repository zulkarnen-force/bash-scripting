#!/bin/bash 

compressed_dir="/home/$USER/backup/$1/compressed"
REMOTE_DIR="labmu:${USER}-$2"

echo $REMOTE_DIR

if [ -z "$1" ]; then
    echo "container name of folder is required on the first argument on the command line"
    exit
fi

if [ -z "$2" ]; then
    echo "please specify project name on the second argument on the command line"
    exit
fi

# Change to the compressed directory
cd "$compressed_dir"

# Get the name of the oldest compressed file
old_compressed=$(ls -t | tail -n 1)

# Check if the file exists before attempting to copy and remove
if [ -z "$old_compressed" ]; then
    echo "No compressed file found in $compressed_dir"
    exit
fi

echo "Copying $old_compressed into r2 on $REMOTE_DIR"

# Execute rclone command and store the output in a variable
rclone_output=$(rclone copy -P -vv "$old_compressed" "$REMOTE_DIR")

# Check the exit status of the rclone command
if [ $? -eq 0 ]; then
    # If rclone command succeeds, remove the compressed file
    echo "Copy completed successfully. Removing $old_compressed from $compressed_dir"
    rm "$old_compressed"
    echo "Removed $old_compressed from $compressed_dir"
else
    # If rclone command fails, display an error message and the command's output
    echo "Error: rclone copy failed. $old_compressed was not removed."
    echo "Command output: $rclone_output"
fi
