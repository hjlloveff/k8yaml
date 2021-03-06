#!/bin/bash
#make sure are put under /home/deployer/sqls
if [[ ${#INIT_MYSQL_HOST} == 0 ]]; then
	INIT_MYSQL_HOST=172.17.0.1
fi
if [[ ${#INIT_MYSQL_USER} == 0 ]]; then
	INIT_MYSQL_USER=root
fi
if [[ ${#INIT_MYSQL_PASSWORD} == 0 ]]; then
	INIT_MYSQL_PASSWORD=password
fi

docker exec -i mysql mysql -h$INIT_MYSQL_HOST -u$INIT_MYSQL_USER -p$INIT_MYSQL_PASSWORD < database.sql
docker exec -i mysql mysql -h$INIT_MYSQL_HOST -u$INIT_MYSQL_USER -p$INIT_MYSQL_PASSWORD < authentication_v1.sql
docker exec -i mysql mysql -h$INIT_MYSQL_HOST -u$INIT_MYSQL_USER -p$INIT_MYSQL_PASSWORD < task_init.sql
docker exec -i mysql mysql -h$INIT_MYSQL_HOST -u$INIT_MYSQL_USER -p$INIT_MYSQL_PASSWORD < backend_log.sql
docker exec -i mysql mysql -h$INIT_MYSQL_HOST -u$INIT_MYSQL_USER -p$INIT_MYSQL_PASSWORD < emotibot.sql
# docker exec -i mysql mysqldump -h10.0.0.100 -uroot -ppassword emotibot taskenginescenario --where=" userID='010841BE020C57DFF58978F74E26DC403'" >task_cmbc_csbot_20180104.sql
