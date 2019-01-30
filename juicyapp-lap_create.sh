#!/bin/bash

docker run -it \
    --name juicyapp-lap \
    -p 2222:22 -p 8000:80 -p 8001:443 \
    --network bridge \
    --link redis:redis --link mysql:db \
    --volume /Users/erickoo/Workspace/www:/var/www/html \
    --restart always \
    juicyapp-eric-lap:latest
