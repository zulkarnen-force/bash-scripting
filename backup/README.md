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

0 2 * * * curl -sSL https://raw.githubusercontent.com/zulkarnen-force/backup_database_container/refs/heads/main/backup.bash | bash -s -- -c db.sotabar -u root -p password -t mysql -n sotabar >> ~/docker-backup/logs/backup.log 2>&1
