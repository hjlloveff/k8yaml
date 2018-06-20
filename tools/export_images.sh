#!/bin/bash

mkdir -p images

docker images > ./images.txt
awk '{print $3}' ./images.txt > ./images_cut.txt
while read LINE
do
#echo $LINE
docker save $LINE > ./images/$LINE.tar
echo ok
done < ./images_cut.txt
echo finish

