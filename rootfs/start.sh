#!/bin/bash
rm -rf /home/container/.nginx/tmp/*

export WINEDEBUG=-all,fixme-all
export WINEARCH=win64

echo "⟳ Starting Nginx..."
/usr/sbin/nginx -c /home/container/.nginx/nginx/nginx.conf -p /home/container/.nginx/
echo "✓ started Nginx..."
echo "⟳ Starting FS22..."
wine /home/container/fs22/dedicatedServer.exe