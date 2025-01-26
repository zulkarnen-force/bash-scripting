```bash
0 */6 * * * curl -sL https://raw.githubusercontent.com/zulkarnen-force/bash-scripting/refs/heads/main/rclone/remote_backup.bash | bash -s -- --remote-name pcloud706 --remote-dir MyBackups copy -e /home/zulkarnen/Developments/DevOps/bash-scripting/rclone/exclude_pcloud706.txt >> $HOME/backup.log 2>&1
```