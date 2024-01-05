#!/bin/bash
folders=(
	/var/www/html/simades-sotabar.pamekasankab.go.id
	/var/www/html/simades-sanadaja.pamekasankab.go.id
	/var/www/html/simades-tlontoraja.pamekasankab.go.id
	/var/www/html/bindang.pamekasankab.go.id
	/var/www/html/dempotimur.pamekasankab.go.id
	/var/www/html/dempobarat.pamekasankab.go.id
	/var/www/html/sanatengah.pamekasankab.go.id
	/var/www/html/batukerbuy.pamekasankab.go.id
	/var/www/html/tagangserdaja.pamekasankab.go.id
)

for folder in "${folders[@]}"
do
	cd "$folder"
	pwd
	git checkout -- initial_folder.sh
	git pull
	chmod +x ./initial_folder.sh
	bash ./initial_folder.sh
done
