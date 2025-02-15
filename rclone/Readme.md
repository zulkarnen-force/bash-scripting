```bash
0 */6 * * * curl -sL https://raw.githubusercontent.com/zulkarnen-force/bash-scripting/refs/heads/main/rclone/remote_backup.bash | bash -s -- -r mega -d Ubuntu-24.10 -i /home/zulkarnen/Developments/DevOps/bash-scripting/rclone/backup_documents_mega.txt  copy >> $HOME/backup.log 2>&1
```


```bash
 curl -sL https://raw.githubusercontent.com/zulkarnen-force/bash-scripting/refs/heads/main/rclone/remote_backup.bash | bash -s -- -r mega -d Ubuntu-24.10 -i ./backup_documents_mega.txt sync
```


```bash
./backup_single_folder.bash --folder /mnt/zulkarnen/Developments/Personal/Kubernetes/k8s-labmu/dom -d ZKN -r mega copy
```


```bash
curl -sSL https://raw.githubusercontent.com/zulkarnen-force/bash-scripting/main/rclone/backup_database_host.bash | bash -s -- --db_type mysql --db_name db_penduduk_sotabar --password Dataku_2023 -b simades --username root --remote-name pcloud706 --retain 3
```

```bash
0 0 * * * curl -sSL https://raw.githubusercontent.com/zulkarnen-force/bash-scripting/main/rclone/backup_database_host.bash | bash -s -- --db_type mysql --db_name db_penduduk_sotabar --password Dataku_2023 -b simades --username root --remote-name pcloud706 --retain 3 >> /var/log/backup.log 2>&1
```
