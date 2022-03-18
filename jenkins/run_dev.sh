#!/bin/bash

set -o nounset
set -o errexit
set -o verbose
set -o xtrace

CID=$(docker ps -a| grep ce-dev | awk '{print $1}')

if [ ! $CID ]; then 
    echo 'container is null !!!'
else
    temp_date=$(date "+%Y-%m-%d-%H-%M-%S")
    temp_log=$(docker inspect --format '{{.LogPath}}' $CID)
    tar -zcvf /mnt/log/ce-dev-$temp_date.tar.gz $temp_log

    docker rm -f $CID
    docker image prune -a -f
fi

#\cp -rf /mnt/app/jenkins/workspace/mdd-dev/mdd-engine-web/target/mdd-engine-web-"$1".jar /mnt/app/mdd-engine
#\mv -f /mnt/app/mdd-engine/mdd-engine-web-"$1".jar /mnt/app/mdd-engine/mdd-engine-web.jar
cd /mnt/app/excel-engine
docker build -f /mnt/app/excel-engine/DockerFile_MDD_DEV -t excel-engine-dev:1.0.0 .
docker run --cap-add=SYS_PTRACE -v /etc/localtime:/etc/localtime:ro -d -p 8282:8282 mdd-engine-dev:1.0.0

#temp_sun=$(docker ps -a| grep mdd-engine-sun | awk '{print $1}')
#tail -f `docker inspect --format='{{.LogPath}}' $temp_sun`

