#/bin/bash
OPTS=$(getopt -o c:d:u:p:t: -n "$0" -- "$@")
eval set -- "$OPTS"

usage() {
   echo "\nUsage: "
   echo  "     $0 [-c|<value>] [-d| <value>] [-u| <value>] [-p| <value>]\n"
   echo "Export the contents of a database in a container.\n"
   echo "Options: "
   echo "  -c     Container name."
   echo "  -d     Database name."
   echo "  -u     User authenticated."
   echo "  -p     Password for user authenticated."
   echo "  -t     Type of database: [mongo|mysql]."
   echo 
   echo "See https://git.muhammadiyah.or.id/labmu-developer-team/research-ci-cd/-/wikis/Home-Page for more information."
   exit 1
}


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
    -t) 
        type=$2
        shift 2
        ;;
    *) 
        break
        ;;
    esac
done

if [ -z "$container" ] || [ -z "$database" ] || [ -z "$user" ] || [ -z "$password" ] || [ -z "$type" ]; then
    usage
fi

USER_NAME=$(whoami)
CURRENT_DATE=`date '+%Y-%m-%d'`
BACKUP_DIR="/home/$USER_NAME/backup/$database/$CURRENT_DATE/raw"
mkdir -p $BACKUP_DIR

error_log="${BACKUP_DIR}/dump.log"

if [ "$type" = "mongo" ]; then
    MONGO_SCRIPT="mongodump --username $user --password $password --test --authenticationDatabase=admin --db $database --gzip --out /backup"
    docker exec "$container" bash -c "$MONGO_SCRIPT" > "$error_log" 2>&1
    docker cp "$container:/backup/$database/." "$BACKUP_DIR"
    echo "Backup database $type completed successfully. Check ${BACKUP_DIR} for details."
elif [ "$type" = "mysql" ]; then
   docker exec "$container" mysqldump -u"$user" -p"$password" "$database" > "${BACKUP_DIR}/${database}-$(date +%Y-%m-%d-%H-%M-%S).sql" 2> "$error_log"
    echo "Backup  database $type completed successfully. Check ${BACKUP_DIR} for details."
else
    echo "Unsupported database type: $type"
    usage
fi