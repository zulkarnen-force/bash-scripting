```bash
 ./backup_to_external_disk.bash -d /media/zulkarnen/BackupDisk/backup -s /home/zulkarnen -e ./backup_excludes.txt
```

```bash
0 * * * * /backup_folder_new.bash -r pcloud706 -s "/home/zulkarnen/Documents/Secret Directory" -t 3 -n secret-directory
```

or using CURL

```bash
curl -fsSl https://raw.githubusercontent.com/zulkarnen-force/bash-scripting/main/backup/backup_folder_new.bash | bash -s -- -r pcloud706 -s "/home/zulkarnen/Documents/Secret Directory" -t 3 -n secret-directory
```

```bash
curl -fsSl https://raw.githubusercontent.com/zulkarnen-force/bash-scripting/main/backup/backup.bash | bash -s -- \
  --target=/home/zulkarnen \
  --includes=Videos,Documents \
  --remote=pcloud706 \
  --remote-folder=docs-videos \
  --log-file=/var/log/rclone_backup.log
```

```bash
0 2 * * * curl -sSL https://raw.githubusercontent.com/zulkarnen-force/backup_database_container/refs/heads/main/backup.bash | bash -s -- -c db.sotabar -u root -p password -t mysql -n sotabar >> ~/docker-backup/logs/backup.log 2>&1
```


```bash
python3 container_backup.py \
  --container db.sotabar \
  --db-type mysql \
  --db-name db_penduduk_sotabar \
  --db-user root \
  --db-password password \
  --remote pcloud706:my-backups  \
  --retention 3
```


```bash
python3 container_backup.py \
  --container db_authserver_dev  \
  --db-type mongodb \
  --db-name authserver \
  --db-user root \
  --db-password supersecret \
  --remote pcloud706:test-authserver  \
  --retention 3
```


```bash
python3 folder.py --folder=/home/zrx/Developments/Bash/bash-scripting  --remote pcloud706:test-bash --retention  3 --exclude .git
```