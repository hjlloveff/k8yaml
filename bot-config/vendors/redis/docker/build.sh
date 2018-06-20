#!/bin/bash

# ===================================================================
# Common headers
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
source $DIR/../../../env.sh
if [ $? -ne 0 ]; then
  echo "Erorr, can't open envfile: $1"
  exit 1
fi
# ===================================================================

CNAME=redis
DOCKER_IMG=$DEVENV_DOCKER_REPO/$CNAME

docker build -t $DOCKER_IMG .
