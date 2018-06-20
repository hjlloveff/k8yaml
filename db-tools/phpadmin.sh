docker rm -f myadmin
docker run --name myadmin -d -e PMA_HOST=172.17.0.1 -p 3380:80 docker-reg.emotibot.com.cn:55688/phpmyadmin:20180512
