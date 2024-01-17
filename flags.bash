#!/bin/bash

# Define usage function
usage() {
    echo "Usage: $0 [-c|--container <value>] [-d|--database <value>]"
    exit 1
}

# Parse command line options
OPTS=$(getopt -o c:d: --long container:,database: -n "$0" -- "$@")
if [ $? != 0 ]; then
    usage
fi
# Extract options and their arguments into variables
eval set -- "$OPTS"

# echo $2
# echo $OPTS

# Initialize variables
container=""
database=""

# Process options
while true; do
    # shift
    case "$1" in
        -c|--container)
            container="$2"
            shift 2 ;;
        -d|--database)
            database="$2"
            shift 2 ;;
        --)
            shift
            break ;;
        *)
            usage ;;
    esac
done

# Output the values
if [ -n "$container" ]; then
    echo "Container: $container"
fi

if [ -n "$database" ]; then
    echo "Database: $database"
fi
