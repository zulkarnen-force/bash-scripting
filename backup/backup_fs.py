#!/usr/bin/env python3

import argparse
import subprocess
import datetime
import time
import shutil
from pathlib import Path
import yaml
import os

# Argument parsing
parser = argparse.ArgumentParser(description="Filesystem Docker DB Backup Script with YAML config")
parser.add_argument('--config', required=True, help='Path to YAML config file')
parser.add_argument('--output-dir', required=True, help='Backup output directory in host')
parser.add_argument('--retention-days', type=int, default=7, help='Retention in days (ignored if --retention-count is set)')
parser.add_argument('--retention-count', type=int, help='Retention count: keep only the latest N folders')
parser.add_argument('--log-file', default='/var/log/fs_db_backup.log', help='Log file location')
args = parser.parse_args()

# Variables
timestamp = datetime.datetime.now().strftime('%Y-%m-%d_%H-%M-%S')
backup_dir = Path(args.output_dir) / timestamp
log_file = Path(args.log_file)
log_file.parent.mkdir(parents=True, exist_ok=True)

def log(message):
    print(message)
    with open(log_file, "a") as f:
        f.write(f"[{datetime.datetime.now()}] {message}\n")

def run_backup(db):
    db_type = db['type']
    container = db['container']
    username = db['username']
    password = db['password']
    database = db['database']
    output_file = backup_dir / f"{db_type}_{database}.tar.gz"
    env = os.environ.copy()

    if db_type == 'mongo':
        cmd = f"mongodump --uri='mongodb://{username}:{password}@localhost:27017/{database}' --archive --gzip --authenticationDatabase=admin"
    elif db_type == 'postgres':
        env['PGPASSWORD'] = password
        cmd = f"pg_dump -U {username} -d {database}"
    elif db_type == 'mysql':
        cmd = f"mysqldump -u{username} -p{password} {database}"
    else:
        log(f"Unsupported database type: {db_type}")
        return False

    log(f"Backing up {db_type}:{database} from container '{container}'...")

    try:
        with open(output_file, 'wb') as f:
            subprocess.run(
                ["docker", "exec", container, "sh", "-c", cmd],
                stdout=f,
                stderr=subprocess.PIPE,
                check=True,
                env=env
            )
        log(f"✅ Backup complete: {output_file}")
        return True
    except subprocess.CalledProcessError as e:
        log(f"❌ ERROR: Backup failed for {db_type}:{database}: {e.stderr.decode()}")
        return False

# Create backup folder
backup_dir.mkdir(parents=True, exist_ok=True)
log(f"🔄 Starting backup to {backup_dir}")

# Load config file
with open(args.config) as f:
    config = yaml.safe_load(f)

# Run backups and track status
all_success = True
for db in config.get("databases", []):
    success = run_backup(db)
    if not success:
        all_success = False

if all_success:
    log("✅ All backups completed successfully.")

    # === Retention cleanup ===
    backup_folders = sorted(
        [d for d in Path(args.output_dir).iterdir() if d.is_dir()],
        key=lambda x: x.name  # name is in timestamp format, so sorting works
    )

    if args.retention_count is not None:
        log(f"🧹 Retention policy: keep only the latest {args.retention_count} folders")
        excess = backup_folders[:-args.retention_count]
    else:
        log(f"🧹 Retention policy: remove folders older than {args.retention_days} days")
        now = time.time()
        excess = []
        for folder in backup_folders:
            try:
                folder_time = time.mktime(datetime.datetime.strptime(folder.name, '%Y-%m-%d_%H-%M-%S').timetuple())
                age_days = (now - folder_time) / 86400
                if age_days > args.retention_days:
                    excess.append(folder)
            except ValueError:
                continue  # Skip invalid folder names

    for folder in excess:
        log(f"🗑️ Deleting old backup: {folder}")
        shutil.rmtree(folder)

    log("✅ Backup and cleanup process finished.")
else:
    log("⚠️ Skipping retention cleanup due to backup failure.")
