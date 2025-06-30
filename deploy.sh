#!/bin/bash
TARGET_IP=$1
KEY=$2
APP_USER=ubuntu

# Copy application
scp -i $KEY -r ./app $APP_USER@$TARGET_IP:/home/ubuntu/

# Install dependencies and run the app
ssh -i $KEY $APP_USER@$TARGET_IP << EOF
    cd /home/ubuntu/app
    npm install
    pkill node || true
    nohup node index.js > app.log 2>&1 &
EOF
