#!/bin/bash
rm -rf /home/container/.nginx/tmp/*

echo "⟳ Starting Nginx..."
/usr/sbin/nginx -c /home/container/.nginx/nginx/nginx.conf -p /home/container/.nginx/
echo "✓ started Nginx..."
echo "⟳ Starting FS22..."
wine /home/container/fs22/dedicatedServer.exe