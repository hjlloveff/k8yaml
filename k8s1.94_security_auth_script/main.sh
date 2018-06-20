#!/bin/bash

source generate_auth_conf.sh
source function.sh

DEP_ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
K8SNUMBER=${#k8sclusterip[@]}
KUBE_KEY_DIR=$DEP_ROOT/kube-key

mkdir kube-key
# You have to sure this setting is correct on openssl.conf
cp openssl.conf kube-key/
gen_cluster_root_cakey
gen_apiserver_cakey_csr
gen_apiserver_pem
gen_node_auth
configsetting
