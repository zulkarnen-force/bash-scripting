#/bin/bash
OPTS=$(getopt -o c:d: -n "$0" -- "$@")
eval set -- "$OPTS"
container=""

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

echo "Container: $container"
echo "Database: $database"

