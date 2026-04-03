import argparse
import subprocess
import datetime
import os
import tarfile
import tempfile
import fnmatch
import shlex  # Added for safe quoting

GLOB_CHARS = set("*?[]")

def run_command(command):
    """Run shell command and return output or raise error."""
    result = subprocess.run(command, shell=True, text=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    if result.returncode != 0:
        raise Exception(f"Command failed: {result.stderr}")
    return result.stdout.strip()

def should_exclude(rel_path, exclude_patterns):
    """Check if a relative path matches any exclude pattern (directory or file, recursively)."""
    rel_path = rel_path.lstrip("/")  # Only strip leading slashes, not dots
    rel_path_norm = rel_path.replace(os.sep, "/")
    for pattern in exclude_patterns:
        pat = pattern.rstrip("/")
        # Exclude if the path is or is under the excluded pattern
        if rel_path_norm == pat or rel_path_norm.startswith(pat + "/"):
            return True
        if fnmatch.fnmatch(rel_path_norm, pattern):
            return True
    return False

def should_include(rel_path, only_patterns):
    """Check if a relative path matches any include pattern.

    If no include patterns are provided, everything is included by default.
    """
    if not only_patterns:
        return True

    rel_path = rel_path.lstrip("/")
    rel_path_norm = rel_path.replace(os.sep, "/")
    base_name = os.path.basename(rel_path_norm)

    for pattern in only_patterns:
        pat = pattern.strip()
        if not pat:
            continue

        # Directory selector (e.g. .ssh/) includes all nested files.
        if pat.endswith("/"):
            dir_pat = pat.rstrip("/")
            if rel_path_norm == dir_pat or rel_path_norm.startswith(dir_pat + "/"):
                return True
            continue

        # Match exact relative path, glob relative path, or basename glob.
        if (
            rel_path_norm == pat
            or fnmatch.fnmatch(rel_path_norm, pat)
            or fnmatch.fnmatch(base_name, pat)
        ):
            return True

    return False

def should_descend(rel_dir_path, only_patterns):
    """Return True if walking into this directory can still match --only patterns."""
    if not only_patterns:
        return True

    rel_dir = rel_dir_path.lstrip("/").replace(os.sep, "/")

    for pattern in only_patterns:
        pat = pattern.strip()
        if not pat:
            continue

        # Directory-only selectors let us aggressively prune unrelated branches.
        if pat.endswith("/"):
            target = pat.rstrip("/")
            if rel_dir == target:
                return True
            if target.startswith(rel_dir + "/"):
                return True
            if rel_dir.startswith(target + "/"):
                return True
            continue

        # Path-like selectors (contains '/') also support prefix pruning.
        if "/" in pat and not any(ch in pat for ch in "*?[]"):
            if rel_dir == pat:
                return True
            if pat.startswith(rel_dir + "/"):
                return True
            if rel_dir.startswith(pat + "/"):
                return True
            continue

        # Basename or glob selectors can match anywhere; cannot prune safely.
        return True

    return False

def has_glob_chars(pattern):
    return any(ch in pattern for ch in GLOB_CHARS)

def is_direct_only_mode(folder_path, only_patterns):
    """True when all --only patterns are explicit relative paths/directories.

    Examples:
    - .ssh/
    - docs/secret.txt
    """
    if not only_patterns:
        return False

    for pattern in only_patterns:00:29:05+00:00 warn agent/embedded {"subsystem":"agent/embedded"} {"event":"embedded_run_agent_end","tags":["error_handling","lifecycle","agent_end","assistant_error"],"runId":"39092e0a-94d3-4a52-9095-a05e27b4cec7","isError":true,"error":"500 {\"error\":\"model requires more system memory (16.8 GiB) than is available (12.6 GiB)\"}","failoverReason":"timeout","model":"qwen3.5:latest","provider":"ollama","rawErrorPreview":"500 {\"error\":\"model requires more system memory (16.8 GiB) than is available (12.6 GiB)\"}","rawErrorHash":"sha256:ffee73728f78"} embedded run agent end
        pat = pattern.strip()
        if not pat:
            continue
        if has_glob_chars(pat):
            return False

        # Path selectors are always direct.
        if pat.endswith("/") or "/" in pat:
            continue

        # Bare names are direct only when they resolve under the backup root.
        abs_target = os.path.abspath(os.path.join(folder_path, pat))
        try:
            is_inside = os.path.commonpath([folder_path, abs_target]) == folder_path
        except ValueError:
            is_inside = False

        if not (is_inside and os.path.exists(abs_target)):
            return False
    return True

def normalize_only_patterns(folder_path, only_patterns):
    """Normalize --only values.

    If a non-glob pattern points to an existing directory under folder_path,
    treat it as a directory selector (append '/').
    """
    normalized = []
    base_folder = os.path.abspath(folder_path)

    for pattern in only_patterns:
        pat = pattern.strip()
        if not pat:
            continue

        pat = pat.replace(os.sep, "/")
        if has_glob_chars(pat) or pat.endswith("/"):
            normalized.append(pat)
            continue

        abs_target = os.path.abspath(os.path.join(base_folder, pat))
        try:
            is_inside = os.path.commonpath([base_folder, abs_target]) == base_folder
        except ValueError:
            is_inside = False

        if is_inside and os.path.isdir(abs_target):
            normalized.append(pat + "/")
        else:
            normalized.append(pat)

    return normalized

def add_file_to_tar(tar, abs_file_path, folder_path, added_files):
    rel_file_path = os.path.relpath(abs_file_path, folder_path).replace(os.sep, "/")
    if rel_file_path in added_files:
        return
    print(f"[+] Adding file: {rel_file_path}")
    tar.add(abs_file_path, arcname=rel_file_path)
    added_files.add(rel_file_path)

def create_backup(folder_path, backup_file, exclude_patterns, only_patterns):
    """Create a tar.gz archive of the folder, excluding specific files or folders."""
    print(f"[+] Starting backup of: {folder_path}")
    folder_path = os.path.abspath(folder_path)
    normalized_only_patterns = normalize_only_patterns(folder_path, only_patterns)
    effective_exclude_patterns = [] if normalized_only_patterns else exclude_patterns
    if normalized_only_patterns and exclude_patterns:
        print("[+] --only is set; ignoring --exclude patterns")

    with tarfile.open(backup_file, "w:gz") as tar:
        # Fast path: explicit path-based --only patterns, avoid full root traversal.
        if normalized_only_patterns and is_direct_only_mode(folder_path, normalized_only_patterns):
            print("[+] Using direct --only mode (targeted traversal)")
            added_files = set()
            for pattern in normalized_only_patterns:
                pat = pattern.strip()
                if not pat:
                    continue

                rel_target = pat.rstrip("/")
                abs_target = os.path.abspath(os.path.join(folder_path, rel_target))

                # Prevent path traversal outside backup root.
                try:
                    is_inside = os.path.commonpath([folder_path, abs_target]) == folder_path
                except ValueError:
                    is_inside = False

                if not is_inside:
                    print(f"[WARN] Ignoring --only target outside folder: {pat}")
                    continue

                if pat.endswith("/"):
                    if not os.path.isdir(abs_target):
                        print(f"[WARN] --only directory not found: {pat}")
                        continue
                    for root, _, files in os.walk(abs_target):
                        for file in files:
                            add_file_to_tar(tar, os.path.join(root, file), folder_path, added_files)
                else:
                    if os.path.isfile(abs_target):
                        add_file_to_tar(tar, abs_target, folder_path, added_files)
                    elif os.path.isdir(abs_target):
                        print(f"[WARN] --only path is a directory; use trailing '/': {pat}")
                    else:
                        print(f"[WARN] --only file not found: {pat}")
            print(f"[+] Created backup archive: {backup_file}")
            if os.path.exists(backup_file):
                size = os.path.getsize(backup_file)
                print(f"[INFO] Final TAR file size: {get_human_readable_size(size)}")
            else:
                print(f"[WARN] TAR file not found at {backup_file}")
            return

        for root, dirs, files in os.walk(folder_path):
            rel_root = os.path.relpath(root, folder_path)
            if rel_root == ".":
                rel_root = ""

            # In --only mode, prune directory traversal where matches are impossible.
            if normalized_only_patterns:
                for d in list(dirs):
                    rel_dir_path = os.path.join(rel_root, d) if rel_root else d
                    if not should_descend(rel_dir_path, normalized_only_patterns):
                        print(f"[+] Skipping directory tree (not matched by --only): {rel_dir_path}")
                        dirs.remove(d)

            # Exclude directories (do not descend into them)
            excluded_dirs = []
            for d in list(dirs):
                rel_dir_path = os.path.join(rel_root, d) if rel_root else d
                if should_exclude(rel_dir_path, effective_exclude_patterns):
                    print(f"[+] Excluding directory: {rel_dir_path}")
                    excluded_dirs.append(d)
            for d in excluded_dirs:
                dirs.remove(d)
            for file in files:
                rel_file_path = os.path.join(rel_root, file) if rel_root else file
                if should_exclude(rel_file_path, effective_exclude_patterns):
                    print(f"[+] Excluding file: {rel_file_path}")
                elif not should_include(rel_file_path, normalized_only_patterns):
                    print(f"[+] Skipping file (not matched by --only): {rel_file_path}")
                else:
                    print(f"[+] Adding file: {rel_file_path}")
                    tar.add(os.path.join(root, file), arcname=rel_file_path)
    print(f"[+] Created backup archive: {backup_file}")
    if os.path.exists(backup_file):
        size = os.path.getsize(backup_file)
        print(f"[INFO] Final TAR file size: {get_human_readable_size(size)}")
    else:
        print(f"[WARN] TAR file not found at {backup_file}")

def get_human_readable_size(size_bytes):
    for unit in ['B', 'KB', 'MB', 'GB', 'TB']:
        if size_bytes < 1024:
            return f"{size_bytes:.2f} {unit}"
        size_bytes /= 1024
    return f"{size_bytes:.2f} PB"

def upload_to_remote(backup_file, remote_path):
    print(f"[+] Uploading backup file {backup_file} to remote: {remote_path}")
    cmd = f"rclone copy {shlex.quote(backup_file)} {shlex.quote(remote_path)}"
    print(f"[+] Uploading to remote: {cmd}")
    run_command(cmd)

def apply_retention(remote_path, retention):
    print(f"[+] Applying retention policy: keep last {retention} backups in {remote_path}")
    cmd = f"rclone lsf {shlex.quote(remote_path)}"
    output = run_command(cmd)
    files = sorted([line.strip() for line in output.splitlines() if line.strip()])
    if len(files) > retention:
        for file in files[:-retention]:
            delete_cmd = f"rclone delete {shlex.quote(remote_path + '/' + file)}"
            print(f"[+] Deleting old backup: {file}")
            run_command(delete_cmd)
    else:
        print(f"[+] No old backups to delete.")

def main():
    parser = argparse.ArgumentParser(description="Folder backup with rclone and retention")
    parser.add_argument("--folder", required=True, help="Folder path to backup")
    parser.add_argument("--remote", required=True, help="rclone remote path, e.g., remote:folder_backups")
    parser.add_argument("--retention", type=int, default=7, help="Number of backup files to keep")
    parser.add_argument("--exclude", action='append', default=[], help="Files or folders to exclude (can use multiple times)")
    parser.add_argument(
        "--only",
        action='append',
        default=[],
        help="Backup only matching files/folders (can use multiple times), e.g. .ssh/, *.jpeg, secretfile.txt",
    )

    args = parser.parse_args()

    if not os.path.isdir(args.folder):
        raise Exception("The specified folder does not exist or is not a directory")

    timestamp = datetime.datetime.now().strftime("%Y%m%d_%H%M%S")
    folder_name = os.path.basename(os.path.abspath(args.folder))
    filename = f"{folder_name}_{timestamp}.tar.gz"
    backup_file = os.path.join(tempfile.gettempdir(), filename)

    try:
        create_backup(args.folder, backup_file, args.exclude, args.only)
        upload_to_remote(backup_file, args.remote)
        apply_retention(args.remote, args.retention)
    finally:
        if os.path.exists(backup_file):
            os.remove(backup_file)
            print(f"[+] Deleted local temporary file: {backup_file}")

if __name__ == "__main__":
    main()
