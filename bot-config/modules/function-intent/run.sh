#!/bin/bash
REPO=docker-reg.emotibot.com.cn:55688
CONTAINER=function-intent
TAG=$2
NAME=function-intent

#$(git rev-parse --short HEAD)
DOCKER_IMAGE=$REPO/$CONTAINER:$TAG

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

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
  envfile=$1
  echo "# Using envfile: $1"
fi

echo "==========================================================================="
echo "ALERT: Should not use this tool in product environment, use bot-config only"
echo "==========================================================================="

# Start docker
docker rm -f -v $NAME
cmd="docker run -d --name $NAME \
  -v /etc/localtime:/etc/localtime \
  --restart="always" \
  -p $FIS_SERVICE_PORT:80 \
  $DOCKER_IMAGE \
"
#-e WORKERS=$FIS_SERVICE_WORKS \
echo $cmd
eval $cmd
