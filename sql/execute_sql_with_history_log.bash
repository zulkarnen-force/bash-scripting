#!/bin/bash

mysql_user=""
mysql_password=""
mysql_host=""
file="/home/$USER/sql/$1"
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


databases=(
    
)

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
