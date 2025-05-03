import argparse
import subprocess
import datetime
import os
import tarfile
import tempfile
import fnmatch
import shlex  # Added for safe quoting

def run_command(command):
    """Run shell command and return output or raise error."""
    result = subprocess.run(command, shell=True, text=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    if result.returncode != 0:
        raise Exception(f"Command failed: {result.stderr}")
    return result.stdout.strip()

def should_exclude(path, exclude_patterns):
    """Check if a path matches any exclude pattern."""
    for pattern in exclude_patterns:
        if fnmatch.fnmatch(path, pattern) or path.startswith(pattern):
            return True
    return False

def create_backup(folder_path, backup_file, exclude_patterns):
    """Create a tar.gz archive of the folder, excluding specific files or folders."""
    folder_path = os.path.abspath(folder_path)
    with tarfile.open(backup_file, "w:gz") as tar:
        for root, dirs, files in os.walk(folder_path):
            rel_root = os.path.relpath(root, os.path.dirname(folder_path))

            # Exclude directories
            dirs[:] = [d for d in dirs if not should_exclude(os.path.join(rel_root, d), exclude_patterns)]

            for file in files:
                rel_path = os.path.relpath(os.path.join(root, file), os.path.dirname(folder_path))
                if not should_exclude(rel_path, exclude_patterns):
                    tar.add(os.path.join(root, file), arcname=rel_path)
    print(f"[+] Created backup archive: {backup_file}")

def upload_to_remote(backup_file, remote_path):
    cmd = f"rclone copy {shlex.quote(backup_file)} {shlex.quote(remote_path)}"
    print(f"[+] Uploading to remote: {cmd}")
    run_command(cmd)

def apply_retention(remote_path, retention):
    cmd = f"rclone lsf {shlex.quote(remote_path)}"
    output = run_command(cmd)
    files = sorted([line.strip() for line in output.splitlines() if line.strip()])
    if len(files) > retention:
        for file in files[:-retention]:
            delete_cmd = f"rclone delete {shlex.quote(remote_path + '/' + file)}"
            print(f"[+] Deleting old backup: {file}")
            run_command(delete_cmd)

def main():
    parser = argparse.ArgumentParser(description="Folder backup with rclone and retention")
    parser.add_argument("--folder", required=True, help="Folder path to backup")
    parser.add_argument("--remote", required=True, help="rclone remote path, e.g., remote:folder_backups")
    parser.add_argument("--retention", type=int, default=7, help="Number of backup files to keep")
    parser.add_argument("--exclude", action='append', default=[], help="Files or folders to exclude (can use multiple times)")

    args = parser.parse_args()

    if not os.path.isdir(args.folder):
        raise Exception("The specified folder does not exist or is not a directory")

    timestamp = datetime.datetime.now().strftime("%Y%m%d_%H%M%S")
    folder_name = os.path.basename(os.path.abspath(args.folder))
    filename = f"{folder_name}_{timestamp}.tar.gz"
    backup_file = os.path.join(tempfile.gettempdir(), filename)

    try:
        create_backup(args.folder, backup_file, args.exclude)
        upload_to_remote(backup_file, args.remote)
        apply_retention(args.remote, args.retention)
    finally:
        if os.path.exists(backup_file):
            os.remove(backup_file)
            print(f"[+] Deleted local temporary file: {backup_file}")

if __name__ == "__main__":
    main()
