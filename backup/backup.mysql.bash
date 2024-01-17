#/bin/bash
OPTS=$(getopt -o c:d:u:p: -n "$0" -- "$@")
eval set -- "$OPTS"

usage() {
    echo "Usage: $0 [-c|<value>] [-d| <value>]"
    exit 1
}

while true; do
    case "$1" in
     -c)
        container=$2
        shift 2
        ;;
    -d)
        database=$2
        shift 2
        ;;
    -u)
        user=$2
        shift 2
        ;;
    -p)
        password=$2
        shift 2
        ;;
    *)
        break
        ;;
    esac
done

while true; do
    case $1 in 
    -c) 
        container=$2
        shift 2
        ;;
    -d) 
        database=$2
        shift 2
        ;;
    -u) 
        user=$2
        shift 2
        ;;
    -p) 
        password=$2
        shift 2
        ;;
    *) 
        break
        ;;
    esac
done


if [ -z "$container" ]; then
    usage
fi


if [ -z "$database" ]; then
    usage
fi


if [ -z "$user" ]; then
    usage
fi


if [ -z "$password" ]; then
    usage
fi

echo "container: $container"
echo "database: $database"
echo "user: $user"
echo "password: $password"
USER_NAME=$(whoami)
CURRENT_DATE=`date '+%Y-%m-%d'`
BACKUP_DIR="/home/$USER_NAME/backup/$database/$CURRENT_DATE/raw"
mkdir -p $BACKUP_DIR

# Run mysqldump inside the Docker container
error_log="${BACKUP_DIR}/mysqldump_error.log"
docker exec "$container" mysqldump -u"$user" -p"$password" "$database" > "${BACKUP_DIR}/${database}-$(date +%Y-%m-%d-%H-%M-%S).sql" 2> "$error_log"

# Check if the mysqldump command was successful
if [ $? -eq 0 ]; then
    echo "Backup completed successfully."
else
    echo "Backup failed. Check ${error_log} for details."
fi