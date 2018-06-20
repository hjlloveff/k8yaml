if [ "$#" -lt 1 ]; then
    echo "usage: ./deploy_pingan.sh ENV_FILE ENV_TYPE"
    echo "example: ./deploy_pingan.sh pingan.env [db|admin|api1|api2]"
    exit 1
fi

ENV_FILE=$1
ENV_TYPE=$2

SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
ROOT_PATH=$SCRIPT_PATH/../../
DEPLOY_PATH=$ROOT_PATH/deploy
ENV_PATH=$DEPLOY_PATH/conf/generated

sudo chmod -R 777 $DEPLOY_PATH/modules

if [ "$ENV_TYPE" == "db" ]; then
	#  — IP:30.4.38.73
	# deploy solr, mysql, arangodb
	echo "start solr"
	sudo mkdir -p /home/deployer/infrastructure/volumes/solr
	sudo chown -R 8983:8983 /home/deployer/infrastructure/volumes/solr
	cp $DEPLOY_PATH/vendors/solr/conf/solr.xml /home/deployer/infrastructure/volumes/solr
	cp $DEPLOY_PATH/resources/solr/3rd_core.tar /home/deployer/infrastructure/volumes/solr
	cp $DEPLOY_PATH/resources/solr/merge_6_25.tar /home/deployer/infrastructure/volumes/solr
	cd /home/deployer/infrastructure/volumes/solr
	tar xvf 3rd_core.tar
	tar xvf merge_6_25.tar
	cd $DEPLOY_PATH/vendors/solr
	./restart.sh

	echo "start arangodb"
	sudo mkdir -p /home/deployer/infrastructure/volumes/arangodb
	cp $DEPLOY_PATH/resources/arangodb/arango_20171117.tar.gz /home/deployer/infrastructure/volumes/arangodb
	cd /home/deployer/infrastructure/volumes/arangodb
	tar xvf arango_20171117.tar.gz
	cd $DEPLOY_PATH/vendors/arangodb_kg
	./restart.sh

	echo "start mysql"
	cd $DEPLOY_PATH/vendors/mysql
	./restart.sh
	sleep 5
	SQL_PATH=$DEPLOY_PATH/db_init

	docker exec mysql mysql -u root --password=password --host 127.0.0.1 -e  "CREATE DATABASE IF NOT EXISTS emotibot"
	docker exec mysql mysql -u root --password=password --host 127.0.0.1 -e  "CREATE DATABASE IF NOT EXISTS multicustomer"
	docker exec mysql mysql -u root --password=password --host 127.0.0.1 -e  "CREATE DATABASE IF NOT EXISTS backend_log"
	docker exec mysql mysql -u root --password=password --host 127.0.0.1 -e  "CREATE DATABASE IF NOT EXISTS memory"
	docker exec -i mysql mysql -u root --password=password --host 127.0.0.1 emotibot < $SQL_PATH/emotibot.sql
	docker exec -i mysql mysql -u root --password=password --host 127.0.0.1 memory < $SQL_PATH/memory.mysql.create.sql
	docker exec -i mysql mysql -u root --password=password --host 127.0.0.1 backend_log < $SQL_PATH/backend_log.sql
	docker exec -i mysql mysql -u root --password=password --host 127.0.0.1 multicustomer < $SQL_PATH/multicustomer.sql
fi

if [ "$ENV_TYPE" == "admin" ]; then
	#  — IP:30.4.38.74
	echo "start consul"
	sudo mkdir -p /home/deployer/infrastructure/volumes/consul-server
	cd $DEPLOY_PATH/vendors/consul
	./restart.sh localhost leader
	curl -v -X PUT -d '{"Datacenter": "dc1", "Node": "solr", "Address": "192.100.90.51",  "Service": {"Service": "solr", "Port": 8081}}' http://172.17.0.1:8500/v1/catalog/register

	echo "start houta"
	cd $DEPLOY_PATH
	cp -r $DEPLOY_PATH/resources/houta /home/deployer
	sudo chmod -R 777 /home/deployer/houta/Files
	python deploy.py --env pingan --conf_file $ENV_FILE --ignore_env_checking --service houta

	echo "start log-collector"
	python deploy.py --env pingan --conf_file $ENV_FILE --ignore_env_checking --service log-collector
	echo "start faq-platform-clustering"
	python deploy.py --env pingan --conf_file $ENV_FILE --ignore_env_checking --service faq-platform-clustering
	echo "start function-web-service"
	python deploy.py --env pingan --conf_file $ENV_FILE --ignore_env_checking --service function-web-service
	echo "start solr-etl-agent"
	python deploy.py --env pingan --conf_file $ENV_FILE --ignore_env_checking --service solr-etl-agent
	echo "start multicustomer"
	python deploy.py --env pingan --conf_file $ENV_FILE --ignore_env_checking --service multicustomer
fi

if [ "$ENV_TYPE" == "api1" ]; then
	# — IP:30.4.38.84
	cd $DEPLOY_PATH
	echo "start snlu"
	python deploy.py --env pingan --conf_file $ENV_FILE --ignore_env_checking --service snlu-disque
	python deploy.py --env pingan --conf_file $ENV_FILE --ignore_env_checking --service snlu-worker
	python deploy.py --env pingan --conf_file $ENV_FILE --ignore_env_checking --service snlu-web
	echo "start function-content"
	python deploy.py --env pingan --conf_file $ENV_FILE --ignore_env_checking --service function-content
	echo "start emotion-support"
	python deploy.py --env pingan --conf_file $ENV_FILE --ignore_env_checking --service emotion-support
	echo "start word2vec"
	python deploy.py --env pingan --conf_file $ENV_FILE --ignore_env_checking --service wordtovecservice
	echo "start robotwriter"
	python deploy.py --env pingan --conf_file $ENV_FILE --ignore_env_checking --service robotwriter
	echo "start answer_classifier"
	python deploy.py --env pingan --conf_file $ENV_FILE --ignore_env_checking --service answer_classifier
	echo "start custom_inference_service"
	python deploy.py --env pingan --conf_file $ENV_FILE --ignore_env_checking --service custom-inference-service
fi

if [ "$ENV_TYPE" == "api2" ]; then
	# — IP:30.4.38.85
	cd $DEPLOY_PATH
	echo "start controller"
	python deploy.py --env pingan --conf_file $ENV_FILE --ignore_env_checking --service emotibot-controller-2.0
	echo "start faq"
	python deploy.py --env pingan --conf_file $ENV_FILE --ignore_env_checking --service faq-module-2.0
	echo "start intent"
	python deploy.py --env pingan --conf_file $ENV_FILE --ignore_env_checking --service intent-support
	echo "start chat"
	python deploy.py --env pingan --conf_file $ENV_FILE --ignore_env_checking --service chat-service
	echo "start knowledgegraph"
	python deploy.py --env pingan --conf_file $ENV_FILE --ignore_env_checking --service knowledgegraph
fi
