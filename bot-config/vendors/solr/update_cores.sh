#!/bin/bash

# Common headers
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

# Prepare volume
VOL=$EMOTIBOT_INFRASTRUCTURE_VOLUME/$CNAME
mkdir -p $VOL

# move cores to volume
for i in $DIR/cores/* ; do
	echo $i
  cp -r $i $EMOTIBOT_INFRASTRUCTURE_VOLUME/$CNAME/
done
