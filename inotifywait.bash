while inotifywait  -e modify,create,delete -r  /mnt/c/Users/LabMu-ZRX/Documents/Obsidian-Vault/Works/*; do
    echo "oke" >>  /mnt/c/Users/LabMu-ZRX/Documents/sync.obsidian.log
    /bin/bash /mnt/c/Users/LabMu-ZRX/Documents/sync.obsidian.bash
done
