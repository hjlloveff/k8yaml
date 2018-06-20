#!/bin/bash

# ===================================================================
# Common headers
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
source $DIR/../../env.sh
if [ $? -ne 0 ]; then
  echo "Erorr, can't open envfile: $1"
  exit 1
fi
# ===================================================================

CNAME=solr
#DOCKER_IMG="solr:6.0.0"
DOCKER_IMG="docker-reg.emotibot.com.cn:55688/solr:5.5-SUSE-v3"
# Prepare volume
VOL=$EMOTIBOT_INFRASTRUCTURE_VOLUME/$CNAME
mkdir -p $VOL

SOLR_PORT=8081
JMX_PORT=8082
# SOLR_VOL=/home/deployer/data/solr_home

docker rm -f -v solr-cmbc
cmd="docker run -d \
  --restart="always" \
  --name solr  \
  --privileged=true \
  -p $SOLR_PORT:8983 \
  -p $JMX_PORT:8082 \
  -v $VOL:/opt/solr/server/solr \
  -v $DIR/conf/set-heap.sh:/docker-entrypoint-initdb.d/set-heap.sh \
  -v $DIR/conf/set-jmx.sh:/docker-entrypoint-initdb.d/set-jmx.sh \
  -t $DOCKER_IMG"

echo $cmd
eval $cmd
