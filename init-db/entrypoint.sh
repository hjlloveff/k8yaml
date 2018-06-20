#!/bin/bash
IFS=','
read -a SOLRS <<< "${INIT_SOLR_HOSTS}"
read -a SOLR_PORTS <<< "${INIT_SOLR_PORTS}"

length=${#SOLRS[@]}

for ((i = 0; i < $length; i++));
do
	curl -v -X PUT -d '{"Datacenter": "dc1", "Node": "node'$i'", "Address": "'${SOLRS[i]}'",  "Service": {"Service": "solr", "Port": '${SOLR_PORTS[i]}'}}' $INIT_CONSUL_URL/v1/catalog/register
done

if [ "${INIT_MYSQL_INIT}" == "true" ] || [ "${INIT_MYSQL_INIT}" == "TRUE" ] ; then
	./init_mysql.sh
fi
