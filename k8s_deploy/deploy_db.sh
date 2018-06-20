#!/bin/bash

namespace=$(<namespace)
# ==================================================================
# env
# ==================================================================
./restart configmap/configmap.yaml


# ==================================================================
# db
# ==================================================================
./restart db/consul-nodeport.yaml
./restart db/consul.yaml
./restart db/mysql.yaml
./restart db/mysql-nodeport.yaml
./restart db/redis.yaml
./restart db/solr-nodeport.yaml
./restart db/solr.yaml


