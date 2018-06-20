#!/bin/bash
REPO=docker-reg.emotibot.com.cn:55688
CONTAINER=faq_module_2.0
CONTAINER_NAME=faq-module-2.0
TAG=$2
DOCKER_IMAGE=$REPO/$CONTAINER:$TAG
echo "# Launching $DOCKER_IMAGE"
# Check if docker image exists (locally or on the registry)
local_img=$(docker images | grep $REPO | grep $CONTAINER | grep $TAG)
if [ -z "$local_img" ] ; then
  echo "# Image not found locally, let's try to pull it from the registry."
  docker pull $DOCKER_IMAGE
  if [ "$?" -ne 0 ]; then
    echo "# Error: Image not found: $DOCKER_IMAGE"
    exit 1
  fi
fi
echo "# Great! Docker image found: $DOCKER_IMAGE"

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

globalConf="
    -m 20G \
    --restart always \
"

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)"
RUNROOT=$DIR/../
echo "RUN ROOT: $RUNROOT"

moduleConf="
    -p $FAQ_HOST_PORT:$FAQ_PORT \
    --env-file $envfile \
    -v $FAQ_HOST_LOGGER_FILE_DIR:$FAQ_LOGGER_FILE_DIR \
"

docker rm -f -v $CONTAINER
cmd="docker run -d --name $CONTAINER \
    $globalConf \
    $moduleConf \
    $DOCKER_IMAGE \
"

echo $cmd
eval $cmd
