#!/bin/bash

# Build redis-cli
cd /tmp
wget http://download.redis.io/redis-stable.tar.gz
tar xvzf redis-stable.tar.gz
cd redis-stable
make
cp src/redis-cli /usr/local/bin/
chmod 755 /usr/local/bin/redis-cli
cd ~

# Service starts
service rsyslog start
service cron start
service ssh start
service apache2 start

# Install cronjob
crontab /root/juicyapp-crontab

# Run bash to keep container running
/bin/bash
