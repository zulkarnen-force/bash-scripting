#!/usr/bin/env python3

import argparse
import os
import subprocess
import sys
from datetime import datetime
from pathlib import Path
from shutil import which

# Argument parser
parser = argparse.ArgumentParser(description="Database backup script with optional rclone sync")
parser.add_argument("-t", "--db_type", required=True, choices=["psql", "mysql"], help="Database type (psql, mysql)")
parser.add_argument("-n", "--db_name", required=True, help="Database name")
parser.add_argument("-u", "--username", required=True, help="Database username")
parser.add_argument("-p", "--password", required=True, help="Database password")
parser.add_argument("-b", "--backup_dir", default=str(Path.home() / "host-backup"), help="Directory to store backups")
parser.add_argument("-r", "--remote_name", help="rclone remote name")
parser.add_argument("-k", "--retain", type=int, default=3, help="Number of backups to retain")

args = parser.parse_args()

# Create backup path
backup_dir = Path(args.backup_dir) / args.db_name
backup_dir.mkdir(parents=True, exist_ok=True)
timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
backup_file = backup_dir / f"{timestamp}.sql"

# Perform database backup
try:
    if args.db_type == "psql":
        env = os.environ.copy()
        env["PGPASSWORD"] = args.password
        cmd = ["pg_dump", "-U", args.username, args.db_name]
        with open(backup_file, "w") as f:
            subprocess.run(cmd, env=env, check=True, stdout=f)
    elif args.db_type == "mysql":
        cmd = ["mysqldump", f"-u{args.username}", f"-p{args.password}", args.db_name]
        with open(backup_file, "w") as f:
            subprocess.run(cmd, check=True, stdout=f)
    print(f"Backup successful: {backup_file}")
except subprocess.CalledProcessError:
    print("Backup failed.")
    sys.exit(1)

# Retain only the latest N backups
sql_files = sorted(backup_dir.glob("*.sql"), key=os.path.getmtime, reverse=True)
if len(sql_files) > args.retain:
    for old_file in sql_files[args.retain:]:
        old_file.unlink()
    print(f"Old backups deleted, retaining only the latest {args.retain} backups.")
else:
    print(f"No old backups to delete, total backups: {len(sql_files)}.")

# Optional rclone sync
if args.remote_name:
    remote_path = f"{args.remote_name}:{backup_dir}"
    print(f"Syncing backups to remote: {remote_path}")
    if which("rclone") is None:
        print("Error: rclone is not installed or not in PATH.")
        sys.exit(1)
    try:
        subprocess.run(["rclone", "sync", str(backup_dir), remote_path, "--progress"], check=True)
        print(f"Backup synced successfully to remote: {remote_path}")
    except subprocess.CalledProcessError:
        print(f"Failed to sync backup to remote: {remote_path}")
        sys.exit(1)
