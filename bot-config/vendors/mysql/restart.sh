#!/usr/bin/env bash
# TODO: make it into docker-compose!!!

# ===================================================================
# Common headers
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
source $DIR/../../env.sh
if [ $? -ne 0 ]; then
  echo "Erorr, can't open envfile: $1"
  exit 1
fi
# ===================================================================

# Prepare volume
VOL=$EMOTIBOT_INFRASTRUCTURE_VOLUME/mysql
mkdir -p $VOL

# MySQL settings
MYSQL_DOCKER_IMG="mysql:5.7"
MYSQL_CONTAINER_NAME="mysql"
PHPMYADMIN_CONTAINER_NAME="phpmyadmin"
MYSQL_DATABASE="emotibot"
MYSQL_ROOT_PASSWORD="password"

# Kill old dockers
docker rm -f -v $MYSQL_CONTAINER_NAME
docker rm -f -v $PHPMYADMIN_CONTAINER_NAME

# Start new ones
cmd="docker run -d \
  --restart="always" \
  --name ${MYSQL_CONTAINER_NAME} \
  -e MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD} \
  -v $VOL:/var/lib/mysql \
  -v /etc/localtime:/etc/localtime \
  -v $DIR/conf/my.cnf:/etc/mysql/my.cnf \
  -p 3306:3306 \
  $MYSQL_DOCKER_IMG"

echo $cmd
eval $cmd

# Start PHPMyAdmin
# docker run -d --link $MYSQL_CONTAINER_NAME:mysql \
# 	--restart="always" \
#   --name $PHPMYADMIN_CONTAINER_NAME \
#   -e MYSQL_USERNAME=root\
#   -e MYSQL_PASSWORD=$MYSQL_ROOT_PASSWORD \
#   -p 3380:80 corbinu/docker-phpmyadmin

#REF:
# https://coreos.com/products/enterprise-registry/docs/latest/mysql-container.html
# https://registry.hub.docker.com/_/mysql/
# https://github.com/corbinu/docker-phpmyadmin
