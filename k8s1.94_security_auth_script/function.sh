#!/bin/bash

function gen_cluster_root_cakey() {
	cd $KUBE_KEY_DIR	
	openssl genrsa -out ca-key.pem 2048
	openssl req -x509 -new -nodes -key ca-key.pem -days 10000 -out ca.pem -subj "/CN=kube-ca"
	chmod 440 ca-key.pem
	chmod 440 ca.pem
}

function gen_apiserver_cakey_csr() {
	cd $KUBE_KEY_DIR
	openssl genrsa -out apiserver-key.pem 2048
	openssl req -new -key apiserver-key.pem -out apiserver.csr -subj "/CN=kube-apiserver" -config openssl.conf
	chmod 440 apiserver-key.pem
	chmod 440 apiserver.csr
}

function gen_apiserver_pem() {
	cd $KUBE_KEY_DIR
	openssl x509 -req -in apiserver.csr -CA ca.pem -CAkey ca-key.pem -CAcreateserial -out apiserver.pem -days 10000 -extensions v3_req -extfile openssl.conf
	chmod 440 apiserver.pem
}


function gen_node_auth() {
	for(( j=0; j<$K8SNUMBER; j++ ))
	do
		ip=${k8sclusterip[$j]}
		echo $ip
		hostname=${k8sclusterhostname[$j]}
		echo $hostname
		cd $DEP_ROOT
		mkdir output
		cd $DEP_ROOT/output
		mkdir $hostname
		cp ../openssl.conf $DEP_ROOT/output/$hostname
		cd $DEP_ROOT/output/$hostname
		openssl genrsa -out ${hostname}-key.pem 2048
		openssl req -new -key ${hostname}-key.pem -out ${hostname}.csr -subj "/CN=${hostname}" -config openssl.conf
		openssl x509 -req -in ${hostname}.csr -CA ../../kube-key/ca.pem -CAkey ../../kube-key/ca-key.pem -CAcreateserial -out ${hostname}.pem -days 10000 -extensions v3_req -extfile openssl.conf
		echo "ls ${DEP_ROOT}/${ip}"
		ls
	done
}
function configsetting(){
	for(( j=0; j<$K8SNUMBER; j++ ))
	do
		ip=${k8sclusterip[$j]}
                echo $ip
		hostname=${k8sclusterhostname[$j]}
                echo $hostname
		echo " For kubernetes role , ${ip} is master or worker ? If ${ip} is master , press 'M' to setting files . If {ip} is worker , press 'W' to setting files ."
		read -p "M or W ..." answer
		case $answer in
			[Mm]* ) cd $DEP_ROOT ;cp -r master output/$hostname ;sed -i "s/<HOST_IP>/$ip/g" $DEP_ROOT/output/$hostname/master/service/kube-apiserver.service ;sed -i "s/<HOSTNAME>/$hostname/g" $DEP_ROOT/output/$hostname/master/service/kube-proxy.service ;sed -i "s/<HOSTNAME>/$hostname/g" $DEP_ROOT/output/$hostname/master/service/kubelet.service;;
			[Ww]* ) cd $DEP_ROOT ;cp -r worker output/$hostname ; sed -i "s/<MASTER_IP>/${kubelet_connect_master}/g" $DEP_ROOT/output/$hostname/worker/kube-config/worker-https-kubeconfig; sed -i "s/<HOSTNAME>/${hostname}/g" $DEP_ROOT/output/$hostname/worker/service/kubelet.service; sed -i "s/<HOSTNAME>/${hostname}/g" $DEP_ROOT/output/$hostname/worker/service/kube-proxy.service;;
		esac
	done
}

