#!/bin/bash
 CI_COMMIT_BRANCH=$1
 if [ "$CI_COMMIT_BRANCH" == "versioning" ]; then
         echo `APP_ENV="versioning"`
        #  cat .env.example
        #  cat .env
elif [ "$CI_COMMIT_BRANCH" == "development" ]; then  
    cat .env.example >> .env
    cat .env
fi


# echo |
#     echo "$USER"
#     echo "$USER"
#     echo "$USER"


echo -e "===== Start Building Images ====\nAPP_VERSION $VERSION\nTAG_IMAGE $TAG_IMAGE\n================================"
# DOCKER_WEB_CONTAINER_NAME=bukumu_test
# DOCKER_DB_CONTAINER_NAME=db_bukumu_test
# APP_URL="https://buku.muhammadiyah.or.id"
# ASSET_URL="https://buku.muhammadiyah.or.id"
# APP_ENV=development
# APP_NAME=BukuMu
# DB_HOST=db
# DB_DATABASE=bukumu
# DB_USERNAME=root
# DB_PASSWORD=supersecret
# EXPOSE_HTTP=87
# EXPOSE_HTTPS=447
# EXPOSE_DB=27018
# MOUNT_DB=/home/vm005/docker/mounts/bukumu/db
# MOUNT_STORAGE=/home/vm005/docker/mounts/bukumu/storage
# MOUNT_BACKUP=/home/vm005/docker/mounts/bukumu/backup
# MOUNT_THUMBNAIL=/home/vm005/docker/mounts/bukumu/public/thumbnail

