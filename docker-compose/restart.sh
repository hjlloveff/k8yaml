#!/bin/bash

yaml=docker-compose-module.yaml
module=$(cat $yaml | grep $1 | head -n1 | sed -e 's/://g')
if [[ "" == $module ]]; then
	yaml=docker-compose-infra.yaml
	module=$(cat $yaml | grep $1 | head -n1 | sed -e 's/://g')
fi
	

if [[ "" == $module ]]; then
	exit 1
fi

echo "restart "$module "(Y/n)?"
read answer
if [[ "$answer" == "y" ]] || [[ "$answer" == "Y" ]] || [[ -z "$answer" ]]; then
	docker-compose -f $yaml up -d $module
fi
