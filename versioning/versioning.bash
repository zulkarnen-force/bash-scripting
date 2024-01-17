#/bin/bash
OPTS=$(getopt -o :k:v: -n "$0" -- "$@")
eval set -- "$OPTS"

usage() {
    echo "Usage: $0 [-k|<value>] [-v| <value>]"
    exit 1
}

while true; do
    case "$1" in
     -k)
        key="$2"
        shift 2
        ;;
    -v)
        value="$2"
        shift 2
        ;;
    *)
        break
        ;;
    esac
done

if [ -z "$key" ]; then
    usage
fi
if [ -z "$value" ]; then
    usage
fi

future_version=$((value + 1))

curl --location --request PUT "https://git.muhammadiyah.or.id/api/v4/projects/$CI_PROJECT_ID/variables/$key" \
    --header 'PRIVATE-TOKEN: glpat-QsU1xcohc7qaW4x3zeyL' \
    --form "value="$future_version""