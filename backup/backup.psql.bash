#/bin/bash
OPTS=$(getopt -o c:d:u:p:t: -n "$0" -- "$@")
eval set -- "$OPTS"

usage() {
   echo
   echo "Usage: "
   echo  "     $0 [-c|<value>] [-d| <value>] [-u| <value>] [-p| <value>]\n"
   echo "Export the contents of a database in a container.\n"
   echo "Options: "
   echo "  -c     Container name."
   echo "  -d     Database name."
   echo "  -u     User authenticated."
   echo "  -p     Password for user authenticated."
   echo "  -t     Type of database: [mongo|mysql|psql]."
   echo 
   echo "See https://git.muhammadiyah.or.id/labmu-developer-team/research-ci-cd/-/wikis/Home-Page for more information."
   echo ""
   exit 1
}

backup_psql() {
    CURRENT_DATE=`date '+%Y-%m-%d'`
    CURRENT_TIME=`date '+%Y-%m-%d-%H-%M-%S'`
    BACKUP_DIR="/home/$USER_NAME/backup/$database/$CURRENT_DATE"
    mkdir -p $BACKUP_DIR
    FILENAME=`date '+%Y%m%d%H%M%S'`
    docker exec -i "$container" bash -c "pg_dump -U $user -d $database" > "$BACKUP_DIR/$FILENAME.sql"
    echo "Backup database $type completed successfully. Check ${BACKUP_DIR} for details."
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

project_name=$(echo "$database" | sed 's/_/-/g')
USER_NAME=$(whoami)
CURRENT_DATE=`date '+%Y-%m-%d'`
CURRENT_TIME=`date '+%Y-%m-%d-%H-%M-%S'`
BACKUP_DIR="/home/$USER_NAME/backup/$database/$CURRENT_DATE/raw"

error_log="${BACKUP_DIR}/dump.log"

case $type in

  psql)
    backup_psql
    ;;

  mongo)
    echo "$database is not supported"
    ;;

  msql)
    echo "$database is not supported"
    ;;

  *)
    echo "$database is not supported"
    ;;
esac





