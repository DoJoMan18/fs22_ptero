#!/bin/bash
rm -rf /home/container/.nginx/tmp/*

echo "⟳ Starting Nginx..."
/usr/sbin/nginx -c /home/container/.nginx/nginx/nginx.conf -p /home/container/.nginx/
clear
echo "⟳ Starting Nginx..."
sleep 5
echo "⟳ Starting FS22..."
echo "✓ Successfully started"
wine64 /home/container/steamapps/fs22/dedicatedServer.exe