#!/bin/bash
# rsync -avzp --progress -e 'ssh -p 10000' ./backup.remote.bash vm008@103.19.182.27:/home/vm008/bash/backup.remote.bash

rsync -avzp --progress -e 'ssh -p 10000' ./kadermu.bash vm008@103.19.182.27:/home/vm008/bash/kadermu.bash