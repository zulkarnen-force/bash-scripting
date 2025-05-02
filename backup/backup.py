#!/usr/bin/env python3

import argparse
import os
import subprocess
import datetime
import time
from pathlib import Path

# Argument parsing
parser = argparse.ArgumentParser(description="Flexible RClone backup script in Python")
parser.add_argument('--target', required=True, help='Target directory to backup')
parser.add_argument('--includes', help='Comma-separated list of folders to include')
parser.add_argument('--excludes', help='Comma-separated list of folders to exclude')
parser.add_argument('--remote', default='myremote', help='RClone remote name')
parser.add_argument('--remote-folder', default='structured-backup', help='Remote backup folder')
parser.add_argument('--retention', type=int, default=7, help='Retention in days')
parser.add_argument('--log-file', default='/var/log/rclone_backup.log', help='Log file location')
args = parser.parse_args()

# Variables
target_dir = os.path.abspath(args.target)
date_str = datetime.datetime.now().strftime('%Y-%m-%d_%H-%M-%S')
remote_path = f"{args.remote}:{args.remote_folder}/{date_str}"
log_file = args.log_file

# Check target directory
if not os.path.isdir(target_dir):
    print(f"ERROR: Target directory '{target_dir}' does not exist.")
    exit(1)

# Build rclone command
cmd = [
    "rclone", "copy", target_dir, remote_path,
    "--log-level", "INFO",
    "--log-file", log_file,
    "--progress"
]

# Handle includes
if args.includes:
    includes = args.includes.split(',')
    for inc in includes:
        cmd.append(f"--include=/{inc.strip()}/**")
    cmd.append("--exclude=/**")

# Handle excludes
elif args.excludes:
    excludes = args.excludes.split(',')
    for exc in excludes:
        cmd.append(f"--exclude=/{exc.strip()}/**")

# Log start
start_msg = f"[{datetime.datetime.now()}] Starting backup: {target_dir} -> {remote_path}"
print(start_msg)
Path(log_file).parent.mkdir(parents=True, exist_ok=True)
with open(log_file, "a") as f:
    f.write(start_msg + "\n")

# Run backup
try:
    subprocess.run(cmd, check=True)
except subprocess.CalledProcessError as e:
    print(f"Backup failed: {e}")
    exit(1)

# Log complete
end_msg = f"[{datetime.datetime.now()}] Backup completed"
print(end_msg)
with open(log_file, "a") as f:
    f.write(end_msg + "\n")

# Retention logic
cleanup_msg = f"[{datetime.datetime.now()}] Cleaning up old remote backups older than {args.retention} days"
print(cleanup_msg)
with open(log_file, "a") as f:
    f.write(cleanup_msg + "\n")

# List remote folders
try:
    result = subprocess.run(
        ["rclone", "lsf", f"{args.remote}:{args.remote_folder}/", "--dirs-only"],
        stdout=subprocess.PIPE,
        check=True,
        text=True
    )
    for line in result.stdout.splitlines():
        folder_name = line.strip().rstrip('/')
        try:
            folder_time = time.mktime(datetime.datetime.strptime(folder_name, '%Y-%m-%d_%H-%M-%S').timetuple())
        except ValueError:
            continue  # Skip non-date folders

        age_days = (time.time() - folder_time) / 86400
        if age_days > args.retention:
            del_path = f"{args.remote}:{args.remote_folder}/{folder_name}"
            del_msg = f"Deleting remote folder: {folder_name} (Age: {int(age_days)} days)"
            print(del_msg)
            with open(log_file, "a") as f:
                f.write(del_msg + "\n")
            subprocess.run(["rclone", "purge", del_path])
except subprocess.CalledProcessError as e:
    print(f"Error during retention check: {e}")
    with open(log_file, "a") as f:
        f.write(f"Retention cleanup error: {e}\n")
