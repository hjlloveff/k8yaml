#!/bin/bash
# NOTE:
# DO NOT touch anything outside <EDIT_ME></EDIT_ME>,
# unless you really know what you are doing.

REPO=docker-reg.emotibot.com.cn:55688
# The name of the container, should use the name of the repo is possible
# <EDIT_ME>
CONTAINER=emotibot-controller-20
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
# - max memory = 5G
# - restart = always
globalConf="
  -v /etc/localtime:/etc/localtime \
  -m 5125m \
  --restart always \
"

# <EDIT_ME>
moduleConf="
  -p $EC_HOST_SERVER_PORT:$EC_SERVER_PORT \
  -v $EC_HOST_LOGGER_FILE_DIR:$EC_LOGGER_FILE_DIR \
  --env-file $1 \
"
# </EDIT_ME>
#

docker rm -f -v $CONTAINER
cmd="docker run -d --name $CONTAINER \
  $globalConf \
  $moduleConf \
  $DOCKER_IMAGE \
"
echo $cmd
eval $cmd
