#!/usr/bin/env bash

# ===================================================================
# Common headers
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
source $DIR/../../env.sh
if [ $? -ne 0 ]; then
  echo "Erorr, can't open envfile: $1"
  exit 1
fi
# ===================================================================
source local.env
echo $REDIS_PASSWORD
CNAME=redis
DOCKER_IMG=$DEVENV_DOCKER_REPO/$CNAME
HOST_PORT=6379

docker rm -f -v $CNAME

cmd="\
docker run -d \
  --restart="always" \
  --name $CNAME \
  -p $HOST_PORT:6379 \
  $DOCKER_IMG redis-server --requirepass $REDIS_PASSWORD\
"
echo $cmd
eval $cmd
