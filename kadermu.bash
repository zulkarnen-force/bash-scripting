#!/bin/bash
# Script to do something with specified options

USER_NAME=$(whoami)

# Define a function to display usage
usage() {
    echo "Usage: $0 -f <folder> -p <password> -c <container> -u <user> -n <name> -d <name>"
    exit 1
}

# Parse command line options
while getopts "f:p:c:u:n:d:" opt; do
    case "$opt" in
    f)
        folder=$OPTARG
        ;;
    p)
        password=$OPTARG
        ;;
    c)
        container=$OPTARG
        ;;
    u)
        user=$OPTARG
        ;;
    n)
        name=$OPTARG
        ;;
    d)
        database=$OPTARG
        ;;
    *)
        usage
        ;;
    esac
done

# Check for mandatory options
if [ -z "$folder" ]  || [ -z "$container" ] || [ -z "$user" ]; then
    usage
fi

# Rest of your script
# ...


current_time=`date '+%Y%m%d%H%M%S'`
filename=${database}_${current_time}
compress_filename=${filename}.tar.gz
backup_folder=/home/$(whoami)/backup/$database

if [ ! -d "$backup_folder" ]; then
    mkdir -p $backup_folder
fi

# Example: Print the values
echo "Folder: $folder"
echo "Password: $password"
echo "Container: $container"
echo "User: $user"
echo "Name: $name"
echo "Databae: $database"
echo "Compress: $compress_filename"
echo "current_time: $current_time"
echo "Backup Folder: $backup_folder"
echo "Filename: $filename"


docker exec -i $container pg_dump -U $user $database > ${backup_folder}/${filename}.sql

if [ $? -eq 0 ]; then
     echo "Backup completed and copied to: ${backup_folder}/${filename}.sql"
else
     echo "Backup failed or copy operation failed."
fi

cd $backup_folder

find ./ -type f -mtime +2 -exec tar czvf $compress_filename {} + 

if [ $? -eq 0 ]; then
     echo "Backup on `date +%Y-%m-%d"_"%H_%M_%S`"
     echo "Backup completed and copied to: /home/$(whoami)/backup/kadermu"
else
     echo "Backup failed or copy operation failed."
fi

if [ -f $compress_filename ]; then
     echo "Start copying $compress_filename to labmu:$name" 
     rclone copy $compress_filename labmu:$name \
     && find $folder_name -type f -mtime +2 -exec rm '{}' \; \
     && rm $compress_filename
  echo "Backup on remote completed and copied to: labmu:$name/${compress_filename}"
else
  echo "Not found $compress_filename"
fi
