#!/bin/bash

if [ -d "./images" ]; then
    for image in ./images/*.tar
    do
	    docker load -i $image
    done

    # restart solr
    sudo chown -R 8983:8983 ../infrastructure/volumes/solr/


    # sudo chown -R 100:1000 /home/deployer/infrastructure/volumes/consul-server/
    # cd $WORKING_DIR/vendors/consul
    # ./restart.sh localhost leader

else
    echo "Put your image into ./images!"
fi




