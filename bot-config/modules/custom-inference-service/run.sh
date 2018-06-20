#!/bin/bash
# NOTE:
# DO NOT touch anything outside <EDIT_ME></EDIT_ME>,
# unless you really know what you are doing.

REPO=docker-reg.emotibot.com.cn:55688
# The name of the container, should use the name of the repo is possible
# <EDIT_ME>
CONTAINER=custom_inference_service
CONTAINER_NAME=custom-inference-service
# </EDIT_ME>
TAG=$2
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
# - max memory = 20G
# - restart = always
globalConf="
  -v /etc/localtime:/etc/localtime \
  -v $CIS_HOST_LOGGER_FILE_DIR:/usr/src/custom_inference_service/log
  -m 20G \
  --restart always \
"
# <EDIT_ME>
# Get runroot
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
RUNROOT=$DIR/../
moduleConf="
  -p $CIS_PORT:8888 \
  --env-file $envfile
"
# </EDIT_ME>

docker rm -f -v $CONTAINER
docker rm -f -v $CONTAINER_NAME
cmd="docker run -d --name $CONTAINER_NAME \
  $globalConf \
  $moduleConf \
  $DOCKER_IMAGE \
"
echo $cmd
eval $cmd
