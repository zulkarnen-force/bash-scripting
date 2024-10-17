#!/bin/bash

# Set variables
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_DIR="/home/vm001labmu/tmp"
WORDPRESS_DIR="/app/wp/pku/wordpress"
WP_CONTENT_BACKUP="$BACKUP_DIR/wordpress-wp-content-backup_$TIMESTAMP.tar.gz"
WP_CONFIG_BACKUP="$BACKUP_DIR/wp-config-backup_$TIMESTAMP.tar.gz"
BACKUP_DB="$BACKUP_DIR/wordpress-database-backup_$TIMESTAMP.sql"
MYSQL_CONTAINER_NAME="<your_mysql_container_name>"   # Replace with your MySQL container name
MYSQL_USER="root"                                   # Replace with your MySQL user
MYSQL_PASSWORD="<your_mysql_password>"              # Replace with your MySQL root password
MYSQL_DB="<your_database_name>"                     # Replace with your WordPress database name

# # Backup wp-content folder
# echo "Backing up wp-content folder..."
tar -czvf $WP_CONTENT_BACKUP -C $WORDPRESS_DIR wp-content

# # Backup wp-config.php file
# echo "Backing up wp-config.php file..."
tar -czvf $WP_CONFIG_BACKUP -C $WORDPRESS_DIR wp-config.php

# # Backup WordPress database
# echo "Backing up WordPress database..."
# docker exec $MYSQL_CONTAINER_NAME mysqldump -u $MYSQL_USER -p$MYSQL_PASSWORD $MYSQL_DB > $BACKUP_DB
echo "Backup completed: $WP_CONTENT_BACKUP, $WP_CONFIG_BACKUP"

# Output the backup completion message
# echo "Backup completed: $WP_CONTENT_BACKUP, $WP_CONFIG_BACKUP, and $BACKUP_DB"


# rsync -aP --progress --dry-run -e 'ssh -p 10123' vm001labmu@103.19.182.20:/home/vm001labmu/tmp/wordpress-wp-content-backup_20241009_112017.tar.gz ./