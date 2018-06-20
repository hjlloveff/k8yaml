#!/bin/bash


echo "[ -------- 1. only install DB enter     -------- ]"
echo "[ -------- 2. only install Module enter -------- ]"
echo "[ -------- 3. All-in-one  enter         -------- ]"
echo "[ -------- 4. only remove DB enter      -------- ]"
echo "[ -------- 5. only remove Module enter  -------- ]"
echo "[ -------- 6. All remove  enter         -------- ]"

read mode

echo "mode:"$mode

if [ $mode == "1" ]; then
	echo "[ -------- only install DB  -------- ]"
	docker-compose -f docker-compose-infra.yaml up -d
	curl http://localhost:8500/v1/catalog/services
	curl -sS -X GET 'http://localhost:8500/v1/catalog/service/solr'


elif [ $mode == "2" ]; then
	echo "[ -------- only install Module  -------- ]"
	docker-compose -f docker-compose-module.yaml up -d


elif [ $mode == "3" ]; then
	echo "[ -------- Install All-in-one  -------- ]"
	docker-compose -f docker-compose-infra.yaml up -d
	curl http://localhost:8500/v1/catalog/services
	curl -sS -X GET 'http://localhost:8500/v1/catalog/service/solr'
	docker-compose -f docker-compose-module.yaml up -d


elif [ $mode == "4" ]; then
	echo "[ -------- only remove DB  -------- ]"
        docker-compose -f docker-compose-infra.yaml down
        docker rm -f init-db

elif [ $mode == "5" ]; then
	echo "[ -------- only remove Module  -------- ]"
	docker-compose -f docker-compose-module.yaml down
	
elif [ $mode == "6" ]; then
	echo "[ -------- Remove All-in-one  -------- ]"
	docker-compose -f docker-compose-infra.yaml down 
	docker-compose -f docker-compose-module.yaml down
	docker rm -f $(docker ps -a -q)
else
	echo "[ -------- bye -------- ]"

fi

