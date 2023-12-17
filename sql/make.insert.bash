#!/bin/bash
filename=waru.timur.sql
rm $filename
nama_desa=(
    "SOBIH"
    "KENDAL"
    "DU UMAN"
    "LEMBANAH"
    "TANA MIRA"
    "SONGAI RAJA"
    "GUNUNG TIMUR"
    "GUNUNG TENGAH"
    "CO' GUNUNG ATAS"
    "CO' GUNUNG BAWAH"
)
# make insert statement to insert data $nama_desa
for i in "${nama_desa[@]}"
do
    echo "INSERT INTO tbl_ref_dusun (dusun_nama) VALUES ('${i}');" >> $filename
done