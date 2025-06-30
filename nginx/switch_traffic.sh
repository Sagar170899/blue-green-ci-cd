#!/bin/bash
ENV=$1
cp ~/nginx/$ENV.conf /etc/nginx/sites-enabled/default
echo $ENV > ~/nginx/live_env.txt
nginx -s reload
