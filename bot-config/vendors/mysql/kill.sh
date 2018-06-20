#!/usr/bin/env bash

MYSQL_CONTAINER_NAME="mysql"
PHPMYADMIN_CONTAINER_NAME="phpmyadmin"

docker rm -f -v $MYSQL_CONTAINER_NAME
docker rm -f -v $PHPMYADMIN_CONTAINER_NAME
