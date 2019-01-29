#!/bin/bash

service rsyslog start
service cron start
service ssh start
service apache2 start

# Run bash to keep container running
/bin/bash