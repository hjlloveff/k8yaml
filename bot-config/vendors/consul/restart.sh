#!/bin/bash
ENV=$1
# ===================================================================
# Common headers
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
source $DIR/../../env.sh
source $DIR/$1.env
if [ $? -ne 0 ]; then
  echo "Erorr, can't open envfile: $1"
    exit 1
    fi
# ===================================================================

CONTAINER_NAME=consul
TAG=1.0.2-SUSE
DOCKER_IMG="docker-reg.emotibot.com.cn:55688/$CONTAINER_NAME:$TAG"
docker rm -f $CONTAINER_NAME

# Prepare volume
VOL=$EMOTIBOT_INFRASTRUCTURE_VOLUME/$CONTAINER_NAME/data
mkdir -p $VOL

role=$2
host_ip=$(/usr/sbin/ip addr list $TARGET_INTERFACE| grep -oE 'inet\ \b([0-9]{1,3}\.){3}[0-9]{1,3}\b'  | sed -e "s/inet\ //" -e "s/$suffix$//")
join_ip=$3


if [[ $role == "leader" ]]; then
  cmd="docker run -d \
     --net=host \
     --restart="always" \
     --name $CONTAINER_NAME \
     -e 'CONSUL_ALLOW_PRIVILEGED_PORTS=' \
     -v $VOL:/consul/data \
     -v $DIR/config:/consul/config \
     $DOCKER_IMG agent -ui -server -bind=$host_ip -client 0.0.0.0 -bootstrap-expect=1
  "
elif [[ $role == "follower" ]]; then
  cmd="docker run -d \
     --net=host \
     --restart="always" \
     --name $CONTAINER_NAME \
     -e 'CONSUL_ALLOW_PRIVILEGED_PORTS=' \
     -v $DIR/config:/consul/config \
     -v $VOL:/consul/data \
     $DOCKER_IMG agent -ui -server -bind=$host_ip -client 0.0.0.0  -retry-join=$join_ip\
  "
else
  cmd="docker run -d \
     --net=host \
     --restart="always" \
     --name $CONTAINER_NAME \
     -e 'CONSUL_ALLOW_PRIVILEGED_PORTS=' \
     -v $DIR/config:/consul/config \
     -v $VOL:/consul/data \
     $DOCKER_IMG agent -ui -bind=$host_ip -client 0.0.0.0  -retry-join=$join_ip \
  "
fi



echo $cmd
eval $cmd
