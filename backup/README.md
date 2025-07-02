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

```bash
0 2 * * * curl -sL https://raw.githubusercontent.com/zulkarnen-force/bash-scripting/main/backup/folder.py | /usr/bin/python3 -
  --folder /home/zrx/Documents/Secret Directory
  --remote pcloud706:test-bash
  --retention 5
  --exclude .git
  --exclude .env >> /home/zrx/backup.log 2>&1
```

```bash
curl -sL https://raw.githubusercontent.com/zulkarnen-force/bash-scripting/main/backup/folder.py | /usr/bin/python3 - --folder /home/zulkarnen/Documents/Obsidian --remote pcloud706:ubuntu-24.04.2-obsidian --retention 3 --exclude=works-obsidian/.git
```

## Backup Database Container into File System

```bash
python3 backup_fs.py --config databases.yaml --output-dir ./example/backups/databases
python3 backup_fs.py --config databases.yaml --output-dir ./example/backups/databases --retention-days 10
python3 backup_fs.py --config databases.yaml --output-dir ./example/backups/databases --retention-count 5
```

```bash
# /etc/anacrontab: configuration file for anacron

# See anacron(8) and anacrontab(5) for details.

SHELL=/bin/sh
HOME=/root
LOGNAME=root

# These replace cron's entries
1	5	cron.daily	run-parts --report /etc/cron.daily
7	10	cron.weekly	run-parts --report /etc/cron.weekly
@monthly	15	cron.monthly	run-parts --report /etc/cron.monthly

1       5      zsh-history-backup     curl -sL https://raw.githubusercontent.com/zulkarnen-force/bash-scripting/main/backup/folder.py | /usr/bin/python3 - --folder /home/zulkarnen/ --remote pcloud706:ubuntu-24.04.2 --retention 3 --exclude=Developments --exclude=Videos --exclude=Downloads --exclude=.vscode --exclude=.npm --exclude=.codeium --exclude=snap --exclude=.cache --exclude=.local --exclude=.nvm --exclude=Documents --exclude=.config --exclude=.local --exclude=.cursor --exclude=.docker --exclude=.kube --exclude=.dotnet >> /home/zulkarnen/backup.log 2>&1
1       5      documents-obsidian-backup     curl -sL https://raw.githubusercontent.com/zulkarnen-force/bash-scripting/main/backup/folder.py | /usr/bin/python3 - --folder /home/zulkarnen/Documents/Obsidian --remote pcloud706:ubuntu-24.04.2-obsidian --retention 3 --exclude=works-obsidian/.git >> /home/zulkarnen/backup.log 2>&1
```
