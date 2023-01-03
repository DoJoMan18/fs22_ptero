#!/bin/bash
rm -rf /home/container/.nginx/tmp/*

echo "⟳ Starting Nginx..."
/usr/sbin/nginx -c /home/container/.nginx/nginx/nginx.conf -p /home/container/.nginx/

echo "⟳ Starting FS22..."
echo "✓ Successfully started"
wine /home/container/steamapps/fs22/dedicatedServer.exe

sleep 10

clear