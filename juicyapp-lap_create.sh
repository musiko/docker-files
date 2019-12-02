#!/bin/bash

docker run -it \
    --name juicyapp_lap7.3 \
    -p 22222:22 -p 80:80 -p 81:443 \
    --link redis5:redis --link mysql8:mysql \
    --volume /Users/erickoo/Workspace/www:/var/www/html \
    --restart always \
    juicyapp-eric-lap:php7.3
