docker rm -f mongo-express
docker run --name mongo-express -d -e ME_CONFIG_MONGODB_SERVER=172.17.0.1 -p 3381:8081 docker-reg.emotibot.com.cn:55688/mongo-express:20180512
