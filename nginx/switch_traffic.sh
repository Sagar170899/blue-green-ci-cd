#!/bin/bash
ENV=$1

# Copy the correct NGINX config file
sudo cp ~/nginx/$ENV.conf /etc/nginx/sites-enabled/default

# Update the live environment file (doesn't require sudo)
echo $ENV > ~/nginx/live_env.txt

# Reload NGINX
sudo systemctl reload nginx
