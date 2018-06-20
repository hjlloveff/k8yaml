#!/bin/bash
REPO=docker-reg.emotibot.com.cn:55688
CONTAINER=sentence_type
TAG=$2
DOCKER_IMAGE=$REPO/$CONTAINER:$TAG
source $1

docker rm -f -v sentence_type
cmd="docker run -d --name sentence_type \
    -e ST_SERVICE_PORT=$ST_SERVICE_PORT\
    -v /etc/localtime:/etc/localtime \
    -p $ST_SERVICE_PORT:$ST_SERVICE_PORT\
  $DOCKER_IMAGE \
"
echo $cmd
eval $cmd
