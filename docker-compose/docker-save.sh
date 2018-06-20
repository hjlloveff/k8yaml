#!/bin/sh

mkdir images 

file="docker-compose-infra.yaml"

while read line; do
        #echo ${line:0:6}
        if [ "${line:0:6}" == "image:"  ]; then
        	echo "$line"
                docker pull "${line:7}"
		docker save --output images/"${line:40}".tar "${line:7}"
                echo ""${line:40}".tar"
	fi
done < $file

echo "filename:"$file


file="docker-compose-module.yaml"

while read line; do
        #echo ${line:0:6}
        if [ "${line:0:6}" == "image:"  ]; then
                echo "$line"
		docker pull "${line:7}"
                docker save --output images/"${line:40}".tar "${line:7}"
                echo ""${line:40}".tar"
        fi
done < $file

echo "filename:"$file
