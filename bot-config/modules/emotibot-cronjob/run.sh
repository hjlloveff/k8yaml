#!/bin/bash
REPO=docker-reg.emotibot.com.cn:55688
CONTAINER=emotibot-cronjob
TAG=$2
DOCKER_IMAGE=$REPO/$CONTAINER:$TAG

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
RUNROOT=$DIR/../

echo "RUNROOT : $RUNROOT"

# Load the env file
source $1
if [ $? -ne 0 ]; then
  if [ "$#" -eq 0 ];then
    echo "Usage: $0 <envfile>"
    echo "e.g., $0 dev.env"
  else
    echo "Erorr, can't open envfile: $1"
  fi
  exit 1
else
  echo "# Using envfile: $1"
fi

docker rm -f -v $CONTAINER
cmd="docker run -t -d --name $CONTAINER \
    -m 2048m \
    --restart=on-failure:5 \
    --env-file=$1
    -v /etc/localtime:/etc/localtime \
  $DOCKER_IMAGE \
"

echo $cmd
eval $cmd
