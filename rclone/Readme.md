```bash
0 */6 * * * curl -sL https://raw.githubusercontent.com/zulkarnen-force/bash-scripting/refs/heads/main/rclone/remote_backup.bash | bash -s -- -r mega -d Ubuntu-24.10 -i /home/zulkarnen/Developments/DevOps/bash-scripting/rclone/backup_documents_mega.txt  copy >> $HOME/backup.log 2>&1
```


```bash
 curl -sL https://raw.githubusercontent.com/zulkarnen-force/bash-scripting/refs/heads/main/rclone/remote_backup.bash | bash -s -- -r mega -d Ubuntu-24.10 -i ./backup_documents_mega.txt sync
```


```bash
./backup_single_folder.bash --folder /mnt/zulkarnen/Developments/Personal/Kubernetes/k8s-labmu/dom -d ZKN -r mega copy
```
