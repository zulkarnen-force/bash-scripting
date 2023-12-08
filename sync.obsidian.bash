# rsync -avz --progress "zulkarnen@192.168.1.24:/home/zulkarnen/Documents/Obsidian Vault" /mnt/c/Users/LabMu-ZRX/Documents
# rsync -avz --progress "/mnt/c/Users/LabMu-ZRX/Documents/Obsidian Vault/" "zulkarnen@192.168.1.33:/home/zulkarnen/Documents/Obsidian Vault"
sync_command=$(rsync -avz --dry-run --progress "zulkarnen@192.168.1.33:/home/zulkarnen/Documents/Obsidian Vault" /mnt/c/Users/LabMu-ZRX/Documents)
sync_command_local=$(rsync -avz --dry-run --progress "/mnt/c/Users/LabMu-ZRX/Documents/Obsidian Vault/" "zulkarnen@192.168.1.33:/home/zulkarnen/Documents/Obsidian Vault" )
#echo $sync_command
status_length=`expr length "$sync_command_local"`
# rsync -avz --progress "/mnt/c/Users/LabMu-ZRX/Documents/Obsidian Vault/" "zulkarnen@192.168.1.33:/home/zulkarnen/Documents/Obsidian Vault"
echo $status_length
NOT_CHANGE=210

# rsync -avz --progress "/mnt/c/Users/LabMu-ZRX/Documents/Obsidian Vault/" "zulkarnen@192.168.1.33:/home/zulkarnen/Documents/Obsidian Vault"

# if [ $hai -gt $NOT_CHANGE ]
    # then
    # echo $hai
    # echo Change on remote zulkarnen@192.168.1.33:/home/zulkarnen/Documents/Obsidian Vault
    # rsync -avz --progress "zulkarnen@192.168.1.33:/home/zulkarnen/Documents/Obsidian Vault" /mnt/c/Users/LabMu-ZRX/Documents
    # rsync -avz --progress "/mnt/c/Users/LabMu-ZRX/Documents/Obsidian Vault/" "zulkarnen@192.168.1.33:/home/zulkarnen/Documents/Obsidian Vault"
# fi

# expr length + '$(rsync -avz  --progress "zulkarnen@192.168.1.33:/home/zulkarnen/Documents/Obsidian Vault" /mnt/c/Users/LabMu-ZRX/Documents)'

# rsync -avz --dry-run --progress "zulkarnen@192.168.1.33:/home/zulkarnen/Documents/Obsidian Vault" /mnt/c/Users/LabMu-ZRX/Documents
    
