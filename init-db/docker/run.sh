#!/bin/bash
REPO=docker-reg.emotibot.com.cn:55688
CONTAINER=init-db
TAG=$(git rev-parse --short HEAD)
TAG=$2
DOCKER_IMAGE=$REPO/$CONTAINER:$TAG

source $1
if [ "$?" -ne 0 ];then
    echo "Error, can't open env file: $1"
    echo "Usage: $0 <env file>"
    echo "e.g., $0 dev.env"
    exit 1
else
    envfile=$1
    echo "# Using env file: $envfile"
fi

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)"
RUNROOT=$DIR/../
echo "RUN ROOT: $RUNROOT"


docker rm -f -v $CONTAINER
cmd="docker run --name $CONTAINER \
    --env-file $envfile \
    $DOCKER_IMAGE\
"

echo $cmd
eval $cmd
