#!/bin/bash

if [[ $1 == '-f' ]]; then
	image=$2
	echo $image
	tagImage=${image//docker-reg.emotibot.com.cn:55688/172.16.101.70\/suse_image}
	if [[ "" != $image ]] && [[ "" != $tagImage ]]; then
		echo "push "$tagImage "(yY/n)?"
		read answer
		if [[ "$answer" == "y" ]] || [[ "$answer" == "Y" ]]; then
			docker tag $image $tagImage
			docker push $tagImage
		fi
	fi
elif [[ $1 != '' ]]; then
	image=$(docker ps | awk {'print $2'} | grep $1 | head -n1)
	echo $image
	tagImage=${image//docker-reg.emotibot.com.cn:55688/172.16.101.70\/suse_image}
	if [[ "" != $image ]] && [[ "" != $tagImage ]]; then
		echo "push "$tagImage "(yY/n)?"
		read answer
		if [[ "$answer" == "y" ]] || [[ "$answer" == "Y" ]]; then
			docker tag $image $tagImage
			docker push $tagImage
		fi
	fi
fi
#docker tag $1 
