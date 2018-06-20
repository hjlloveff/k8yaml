#!/bin/bash

CONFIG_FILE=minSheng.env
ENV=minSheng
INIT_TAG=2018050921-02cd6b3
DEP_ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

MUDULES_DIR=$DEP_ROOT/modules

WORKING_DIR=$DEP_ROOT/bot-config


# restart consul
cd $WORKING_DIR/vendors/consul
./restart.sh localhost leader 172.17.0.1

# restart mysql
cd $WORKING_DIR/vendors/mysql
./restart.sh

# restart redis
cd $WORKING_DIR/vendors/redis
./restart.sh

# restart solr
cd $WORKING_DIR/vendors/solr
./restart.sh


sleep 5

#cd $DEP_ROOT/init-db/docker && ./run.sh local.env $INIT_TAG

sleep 5

cd WORKING_DIR
python $WORKING_DIR/deploy.py --service all --env $ENV --conf $CONFIG_FILE --ignore_env_checking




