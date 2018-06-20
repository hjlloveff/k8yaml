#!/bin/bash
# NOTE:
# DO NOT touch anything outside <EDIT_ME></EDIT_ME>,
# unless you really know what you are doing.

REPO=docker-reg.emotibot.com.cn:55688
# The name of the container, should use the name of the repo is possible
# <EDIT_ME>
CONTAINER=common-parser-service
# </EDIT_ME>

# Load env file
if [ "$#" -ne 2 ];then
  echo "Usage: $0 <envfile> <tags>"
  exit 1
else
  envfile=$1
  TAG=$2
  echo "# Using envfile: $envfile, tags: $TAG"
fi

source $envfile
# Get tags from args
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

# global config:
# - use local timezone
# - max memory = 5G
# - restart = always
globalConf="
  -v /etc/localtime:/etc/localtime \
  -m 5125m \
  --restart always \
"
# <EDIT_ME>
HOST_LOG_PATH=/tmp/debug_log
moduleConf="
  --env-file $envfile \
  -p $CPS_DOCKER_PORT:9902 \
  -v $HOST_LOG_PATH:/tmp/CommonParserService
"
# </EDIT_ME>

docker rm -f -v $CONTAINER
cmd="docker run -d --name $CONTAINER \
  $globalConf \
  $moduleConf \
  $DOCKER_IMAGE \
"
echo $cmd
eval $cmd
