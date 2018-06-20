#!/bin/bash
# NOTE:
# DO NOT touch anything outside <EDIT_ME></EDIT_ME>,
# unless you really know what you are doing.

REPO=docker-reg.emotibot.com.cn:55688
# The name of the container, should use the name of the repo is possible
# <EDIT_ME>
CONTAINER=multicustomer
# </EDIT_ME>
TAG=$2
echo "TAG: "${TAG}
DOCKER_IMAGE=$REPO/$CONTAINER:$TAG

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
# - max memory = 5G/10G
# - restart = always
globalConf="
  -v /etc/localtime:/etc/localtime \
  -m 20G \
  --restart always \
"

# <EDIT_ME>
echo "========== Download Jar Ready =========="

# Get runroot
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
RUNROOT=$DIR/../
echo "RUNROOT : $RUNROOT"
# Compose module config
moduleConf="
  -p 14501:9011 \
  -p 14502:873 \
  --env-file $envfile \
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

