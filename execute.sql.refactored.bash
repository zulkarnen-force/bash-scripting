#!/bin/bash

mysql_user="root"
mysql_password="Dataku_2023"
mysql_host="localhost"
file="/home/$USER/sql/$1"
db_file="/home/$USER/sql/databases.txt"
log_file="/home/$USER/sql_execution.log"

# Check if SQL file is provided
if [ -z "$1" ]; then
    echo "Filename of sql file required"
    exit 1
fi

# Ensure the SQL file exists
if [ ! -f "$file" ]; then
    echo "SQL file not found: $file"
    exit 1
fi

# Ensure the database file exists
if [ ! -f "$db_file" ]; then
    echo "Database list file not found: $db_file"
    exit 1
fi

# Read databases from the file into an array
mapfile -t databases < "$db_file"

# Start logging
echo "=== SQL Execution Log ===" >> "$log_file"
echo "Execution started at: $(date)" >> "$log_file"
echo "SQL File: $file" >> "$log_file"

for db in "${databases[@]}"; do
    echo "Executing on database: $db" | tee -a "$log_file"
    if mysql -u"$mysql_user" -p"$mysql_password" -h"$mysql_host" "$db" < "$file" 2>>"$log_file"; then
        echo "Success: Executed on $db" | tee -a "$log_file"
    else
        echo "Error: Failed to execute on $db" | tee -a "$log_file"
    fi
done

echo "Execution completed at: $(date)" >> "$log_file"
echo "=========================" >> "$log_file"
