import os
import shutil
import argparse

def parse_arguments():
    parser = argparse.ArgumentParser(
        description="Move document files from source directories to a destination directory."
    )
    parser.add_argument(
        '--from', dest='from_dirs', action='append', required=True,
        help='Source directory to scan (use multiple times for multiple sources)'
    )
    parser.add_argument(
        '--to', dest='to_dir', required=True,
        help='Destination directory to move files to'
    )
    parser.add_argument(
        '--extensions', type=str, default=".pdf,.epub,.doc,.docx,.xls,.xlsx,.ppt,.pptx,.txt,.odt",
        help='Comma-separated list of document file extensions to move (default includes common types)'
    )
    parser.add_argument(
         '--verbose', action='store_true',
         help='Enable verbose output'
    )
    return parser.parse_args()

def move_files(from_dirs, to_dir, extensions):
    extensions_set = {ext.strip().lower() for ext in extensions.split(",")}

    for src_dir in from_dirs:
        for root, _, files in os.walk(src_dir):
            for file in files:
                ext = os.path.splitext(file)[1].lower()
                if ext in extensions_set:
                    src_path = os.path.join(root, file)
                    dest_path = os.path.join(to_dir, file)

                    # Avoid overwriting
                    base, ext = os.path.splitext(file)
                    counter = 1
                    while os.path.exists(dest_path):
                        dest_path = os.path.join(to_dir, f"{base}_{counter}{ext}")
                        counter += 1
                    if args.verbose:
                         print(f"Moving {src_path} -> {dest_path}")
                    # shutil.move(src_path, dest_path)

if __name__ == "__main__":
    args = parse_arguments()

    # Safety checks
    for directory in args.from_dirs:
        if not os.path.isdir(directory):
            raise ValueError(f"Source directory does not exist: {directory}")
    if not os.path.isdir(args.to_dir):
        raise ValueError(f"Destination directory does not exist: {args.to_dir}")

    move_files(args.from_dirs, args.to_dir, args.extensions)
