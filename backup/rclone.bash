CURRENT_DATE=$(date '+%Y-%m-%d-%H-%M-%S')
APP_ID="sso_new"
SERVER_NAME="vm007-prod"
COMPRESSED_DIR="/app/backup/compressed/$APP_ID"
BACKUP_DIR="/app/backup/"


FILENAME="$SERVER_NAME-$APP_ID-$CURRENT_DATE"
FILE_COMPRESSED="$COMPRESSED_DIR/$FILENAME.tar.gz"d
REMOTE_DIR="$SERVER_NAME-$APP_ID"

tar -cvzf "$FILE_COMPRESSED" -C $BACKUP_DIR "$APP_ID/"
# rclone copy -P -vv $FILE_COMPRESSED labmu:$REMOTE_DIR