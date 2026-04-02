#!/bin/bash

declare -A folders0=(
    [path]='/mnt/nfs-share/dom/storage'
    [name]='dom-storage'
)


declare -n folders
for folders in ${!folders@}; do
curl -sL https://raw.githubusercontent.com/zulkarnen-force/bash-scripting/main/backup/folder.py | /usr/bin/python3 -
  --folder "${folders0[path]}"
  --remote labmu:"${folders0[name]}"
  --retention 7
done
