#!/bin/bash
# NOTE:
# DO NOT touch anything outside <EDIT_ME></EDIT_ME>,
# unless you really know what you are doing.
REPO=docker-reg.emotibot.com.cn:55688
# The name of the container, should use the name of the repo is possible
# <EDIT_ME>
CONTAINER=snlu-web
# </EDIT_ME>

# Get tags from args
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

# Load env file
source $1
if [ "$?" -ne 0 ];then
  echo "Erorr, can't open envfile: $1"
  echo "Usage: $0 <envfile>"
  echo "e.g., $0 dev.env"
  exit 1
else
  envfile=$1
  echo "# Using envfile: $envfile"
fi

# global config:
# - use local timezone
# - max memory = 5G
# - restart = always
globalConf="
  --mount type=bind,src=/etc/localtime,dst=/etc/localtime \
  --limit-memory 5125m \
  --restart-condition any \
  --update-delay 10s \
  -e STATSD_HOST=$STATSD_HOST \
  -e STATSD_PORT=$STATSD_PORT \
  -e STATSD_NAMESPACE=$STATSD_NAMESPACE \
"

# <EDIT_ME>
moduleConf="
  -p $SNLU_WEB_PORT:$SNLU_WEB_PORT \
  --name $CONTAINER \
  $3 \
"
# </EDIT_ME>

cmd="docker service create \
  $globalConf \
  $moduleConf \
  $DOCKER_IMAGE
"

echo $cmd
eval $cmd