#!/bin/bash

# MySQL server connection details
mysql_user="root"
mysql_password="Dataku_2023"
mysql_host="localhost"
file="/home/simades/bash/add_column_usaha.sql"

# Define an array of database names
databases=(
    db_penduduk_batukerbuy
    db_penduduk_bindang
    db_penduduk_dempobarat
    db_penduduk_dempotimur
    db_penduduk_sanadaja
    db_penduduk_sanatengah
    db_penduduk_sotabar
    db_penduduk_tagangserdaja
    db_penduduk_tlontoraja
)
# Loop through the array and execute the SQL commands from the SQL file on each database
for db in "${databases[@]}"; do
    echo $db\n
# Use the `mysql` command to log in, specify the database, and execute the SQL file
    mysql -u"$mysql_user" -p"$mysql_password" -h"$mysql_host" $db < $file;
    # You may add error handling here if necessary
done
