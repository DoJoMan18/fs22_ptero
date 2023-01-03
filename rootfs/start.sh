#!/bin/bash
rm -rf /home/container/.nginx/tmp/*

echo "⟳ Starting Nginx..."
/usr/sbin/nginx -c /home/container/.nginx/nginx/nginx.conf -p /home/container/

echo "⟳ Starting FS22..."
echo "✓ Successfully started"
wine /home/container/FS22/dedicatedServer.exe