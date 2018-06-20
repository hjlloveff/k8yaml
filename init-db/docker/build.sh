#!/bin/bash
REPO=docker-reg.emotibot.com.cn:55688
REPO2=172.16.101.70/suse_image
CONTAINER=init-db
TAG=$(date '+%Y%m%d%H')-$(git rev-parse --short HEAD)
DOCKER_IMAGE=$REPO/$CONTAINER:$TAG
TAG_DOCKER_IMAGE=$REPO2/$CONTAINER:$TAG

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)"

BUILDROOT=$DIR/../

cmd="docker build \
    -t $DOCKER_IMAGE \
    -f $DIR/Dockerfile \
    $BUILDROOT"
echo $cmd
eval $cmd
cmd="docker tag \
    $DOCKER_IMAGE \
    $TAG_DOCKER_IMAGE"
echo $cmd
eval $cmd



