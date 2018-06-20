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
VOL=$DEVENV_ROOT_DOCKER_VOL/$CNAME
mkdir -p $VOL

echo "move need files to volume"
echo "# Run the cmd below:"
cmd="cp $DIR/conf/solr.xml $DIR/conf/zoo.cfg $VOL"

echo $cmd
eval $cmd
