#!/bin/bash
REPO=docker-reg.emotibot.com.cn:55688
CONTAINER=admin-ui
LAST_RELEASE_TAG="20171123-75fed86"
MOUNT_PATH=/home/deployer/infrastructure/volumes/houta/Files
#TAG=$(git rev-parse --short HEAD)

TAG=$2
if [ "$TAG" == "" ]; then
    TAG=$LAST_RELEASE_TAG
fi
DOCKER_IMAGE=$REPO/$CONTAINER:$TAG
echo "TAG: $TAG"
echo "DOCKER_IMAGE: $DOCKER_IMAGE"


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

# Start docker
docker rm -f -v $CONTAINER
cmd="docker run -idt --name $CONTAINER \
  -v /etc/localtime:/etc/localtime \
  -v $MOUNT_PATH:/build/dist/Files \
  --restart="always" \
  -p $ADMIN_HTTP_PORT:80 \
  --env-file $envfile \
  $DOCKER_IMAGE \
"

echo $cmd
eval $cmd
