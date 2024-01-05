#!/bin/bash
mysql_user="root"
mysql_password="Dataku_2023"
mysql_host="localhost"
file="/home/$USER/sql/05012024_surat_nikah.sql"
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

for db in "${databases[@]}"; do
    echo $db\n
    mysql -u"$mysql_user" -p"$mysql_password" -h"$mysql_host" $db < $file;
done
