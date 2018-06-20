#!/bin/sh


for i in images/*;
do
	if [[ ! $i =~ "template" ]]; then
                echo $i
		docker load -i $i
        fi

done

