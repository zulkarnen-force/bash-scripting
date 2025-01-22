# #/bin/bash
# OPTS=$(getopt -o c:d:u:p:t: -n "$0" -- "$@")
# eval set -- "$OPTS"

# usage() {
#    echo
#    echo "Usage: "
#    echo  "     $0 [-c|<value>] [-d| <value>] [-u| <value>] [-p| <value>]\n"
#    echo "Export the contents of a database in a container.\n"
#    echo "Options: "
#    echo "  -c     Container name."
#    echo "  -d     Database name."
#    echo "  -u     User authenticated."
#    echo "  -p     Password for user authenticated."
#    echo "  -t     Type of database: [mongo|mysql]."
#    echo 
#    echo "See https://git.muhammadiyah.or.id/labmu-developer-team/research-ci-cd/-/wikis/Home-Page for more information."
#    echo ""
#    exit 1
# }


# while true; do
#     case $1 in 
#     -c) 
#         container=$2
#         shift 2
#         ;;
#     -d) 
#         database=$2
#         shift 2
#         ;;
#     -u) 
#         user=$2
#         shift 2
#         ;;
#     -p) 
#         password=$2
#         shift 2
#         ;;
#     -t) 
#         type=$2
#         shift 2
#         ;;
#     *) 
#         break
#         ;;
#     esac
# done

# if [ -z "$container" ] || [ -z "$database" ] || [ -z "$user" ] || [ -z "$password" ] || [ -z "$type" ]; then
#     usage
# fi

# USER_NAME=$(whoami)
# CURRENT_DATE=`date '+%Y-%m-%d'`
# CURRENT_TIME=`date '+%Y-%m-%d-%H-%M-%S'`
# BACKUP_DIR="/home/$USER_NAME/backup/$database/$CURRENT_DATE/raw"
# mkdir -p $BACKUP_DIR
# mkdir -p "$BACKUP_DIR/$CURRENT_TIME"

# error_log="${BACKUP_DIR}/dump.log"

# if [ "$type" = "mongo" ]; then
#     MONGO_SCRIPT="mongodump --username $user --password $password --authenticationDatabase=admin --db $database --gzip --out /backup"
#     docker exec "$container" bash -c "$MONGO_SCRIPT" > "$error_log" 2>&1
#     if [ $? -eq 0 ]; then
#         docker cp "$container:/backup/$database/." "$BACKUP_DIR/$CURRENT_TIME"
#         echo "Backup database $type completed successfully. Check ${BACKUP_DIR} for details."
#     else
#         echo "Backup failed. Check ${error_log} for details."
#     fi
# elif [ "$type" = "mysql" ]; then
#     docker exec "$container" mysqldump -u"$user" -p"$password" "$database" > "${BACKUP_DIR}/${database}-$(date +%Y-%m-%d-%H-%M-%S).sql" > "$error_log" 2>&1      
#      if [ $? -eq 0 ]; then
#         echo "Backup database $type completed successfully. Check ${BACKUP_DIR} for details."
#     else
#         echo "Backup failed. Check ${error_log} for details."
#     fi
# else
#     echo "Unsupported database type: $type"
#     usage
# fi


#!/bin/bash
OPTS=$(getopt -o c:d:u:p:t: -n "$0" -- "$@")
eval set -- "$OPTS"

usage() {
    echo
    echo "Usage: "
    echo "     $0 [-c <container>] [-d <database>] [-u <user>] [-p <password>] [-t <type>]"
    echo "Export the contents of a database in a container."
    echo "Options: "
    echo "  -c     Container name."
    echo "  -d     Database name."
    echo "  -u     User for authentication."
    echo "  -p     Password for user."
    echo "  -t     Type of database: [mongo|mysql]."
    echo
    echo "See https://git.muhammadiyah.or.id/labmu-developer-team/research-ci-cd/-/wikis/Home-Page for more information."
    echo ""
    exit 1
}

# Default log function
log() {
    local message="$1"
    echo "$(date +'%Y-%m-%d %H:%M:%S') - $message" >> "$error_log"
}

# Parse arguments
while true; do
    case $1 in 
        -c) container=$2; shift 2 ;;
        -d) database=$2; shift 2 ;;
        -u) user=$2; shift 2 ;;
        -p) password=$2; shift 2 ;;
        -t) type=$2; shift 2 ;;
        *) break ;;
    esac
done

if [ -z "$container" ] || [ -z "$database" ] || [ -z "$user" ] || [ -z "$password" ] || [ -z "$type" ]; then
    usage
fi

USER_NAME=$(whoami)
CURRENT_DATE=$(date '+%Y-%m-%d')
CURRENT_TIME=$(date '+%Y-%m-%d-%H-%M-%S')
BACKUP_DIR="/home/$USER_NAME/backup/$database/$CURRENT_DATE/raw"
error_log="${BACKUP_DIR}/dump.log"
mkdir -p "$BACKUP_DIR/$CURRENT_TIME"

backup_success() {
    log "Backup database $type completed successfully. Check ${BACKUP_DIR} for details."
    echo "Backup completed successfully. Check ${BACKUP_DIR} for details."
}

backup_failure() {
    log "Backup failed. Check ${error_log} for details."
    echo "Backup failed. Check ${error_log} for details."
}

if [ "$type" = "mongo" ]; then
    MONGO_SCRIPT="mongodump --username $user --password $password --authenticationDatabase=admin --db $database --gzip --out /backup"
    log "Starting MongoDB backup..."
    docker exec "$container" bash -c "$MONGO_SCRIPT" > "$error_log" 2>&1
    if [ $? -eq 0 ]; then
        docker cp "$container:/backup/$database/." "$BACKUP_DIR/$CURRENT_TIME"
        backup_success
    else
        backup_failure
    fi
elif [ "$type" = "mysql" ]; then
    MYSQL_SCRIPT="mysqldump -u$user -p$password $database > ${BACKUP_DIR}/${database}-${CURRENT_TIME}.sql"
    log "Starting MySQL backup..."
    docker exec "$container" mysqldump -u"$user" -p"$password" "$database" > "${BACKUP_DIR}/${database}-$(date +%Y-%m-%d-%H-%M-%S).sql" > "$error_log" 2>&1      
    if [ $? -eq 0 ]; then
        backup_success
    else
        backup_failure
    fi
else
    log "Unsupported database type: $type"
    echo "Unsupported database type: $type"
    usage
fi
