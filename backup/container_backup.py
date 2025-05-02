import argparse
import subprocess
import datetime
import os
import tempfile

def run_command(command):
    """Run shell command and return output or raise error."""
    result = subprocess.run(command, shell=True, text=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    if result.returncode != 0:
        raise Exception(f"Command failed: {result.stderr}")
    return result.stdout.strip()

def backup_database(args, backup_file):
    if args.db_type == 'postgres':
        cmd = (
            f"docker exec {args.container} pg_dump -U {args.db_user} {args.db_name} "
            f"| gzip > {backup_file}"
        )
    elif args.db_type == 'mysql':
        cmd = (
            f"docker exec {args.container} sh -c "
            f"\"mysqldump -u{args.db_user} -p'{args.db_password}' {args.db_name}\" "
            f"| gzip > {backup_file}"
        )
    elif args.db_type == 'mongodb':
        dump_dir = tempfile.mkdtemp()
        cmd = (
            f"docker exec {args.container} mongodump --username {args.db_user} "
            f"--password {args.db_password} --db {args.db_name} --authenticationDatabase admin --archive "
            f"| gzip > {backup_file}"
        )
    else:
        raise Exception("Unsupported database type. Choose from postgres, mysql, or mongodb.")
    
    print(f"[+] Running backup command:\n{cmd}")
    run_command(cmd)

def upload_to_remote(backup_file, remote_path):
    cmd = f"rclone copy {backup_file} {remote_path}"
    print(f"[+] Uploading backup to remote:\n{cmd}")
    run_command(cmd)

def apply_retention(remote_path, retention):
    # Get list of files from the remote
    cmd = f"rclone lsf {remote_path}"
    output = run_command(cmd)
    files = [line.strip() for line in output.splitlines() if line.strip()]
    
    # Filter and sort by filename assuming timestamp format
    files = sorted(files)
    
    # Remove older files if retention exceeded
    if len(files) > retention:
        files_to_delete = files[:-retention]
        for file in files_to_delete:
            delete_cmd = f"rclone delete {remote_path}/{file}"
            print(f"[+] Deleting old backup: {file}")
            run_command(delete_cmd)

def main():
    parser = argparse.ArgumentParser(description="Containerized DB backup with rclone retention")
    parser.add_argument("--container", required=True, help="Docker container name")
    parser.add_argument("--db-type", required=True, choices=["postgres", "mysql", "mongodb"], help="Database type")
    parser.add_argument("--db-name", required=True, help="Database name")
    parser.add_argument("--db-user", required=True, help="Database user")
    parser.add_argument("--db-password", required=True, help="Database password")
    parser.add_argument("--remote", required=True, help="rclone remote path, e.g., remote:db_backups")
    parser.add_argument("--retention", type=int, default=7, help="Number of backup files to keep")
    args = parser.parse_args()

    timestamp = datetime.datetime.now().strftime("%Y%m%d_%H%M%S")
    filename = f"{args.db_name}_{timestamp}.sql.gz"
    backup_file = os.path.join(tempfile.gettempdir(), filename)

    try:
        backup_database(args, backup_file)
        upload_to_remote(backup_file, args.remote)
        apply_retention(args.remote, args.retention)
    finally:
        if os.path.exists(backup_file):
            os.remove(backup_file)

if __name__ == "__main__":
    main()

# python backup_db.py \
#   --container db.sotabar \
#   --db-type mysql \
#   --db-name db_penduduk_sotabar \
#   --db-user root \
#   --db-password password \
#   --remote pcloud706:my-backups  \
#   --retention 7
