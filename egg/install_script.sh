#!/bin/bash
# ghcr.io/parkervcp/installers:debian
# bash

# Variables:
# STEAM_USER - Steam username
# STEAM_PASS - Steam password
# STEAM_AUTH - Steam Auth code
# SRCDS_APPID - Steam APP ID
# INSTALL_FLAGS - Custom flags
# ADM_PASS - Admin password
# HTTP_PORT - HTTP PORT

# just in case someone removed the SteamCMD defaults.
if [[ "${STEAM_USER}" == "" ]] || [[ "${STEAM_PASS}" == "" ]]; then
    echo -e "steam user is not set.\n"
    echo -e "Using anonymous user.\n"
    STEAM_USER=anonymous
    STEAM_PASS=""
    STEAM_AUTH=""
else
    echo -e "user set to ${STEAM_USER}"
fi

if [ ! -d /mnt/server ]; then
    mkdir -p /mnt/server/
fi

# cd /tmp
# curl -sSL -o vkd3d-proton-2.8.tar.zst https://github.com/HansKristian-Work/vkd3d-proton/releases/download/v2.8/vkd3d-proton-2.8.tar.zst
# mkdir -p /mnt/server/.vkd3d/
# apt install zstd
# tar -I zstd -xvf vkd3d-proton-2.8.tar.zst -C /mnt/server/.vkd3d
# cd /mnt/server/.vkd3d/vkd3d-proton-2.8
# chmod +x /mnt/server/.vkd3d/vkd3d-proton-2.8/setup_vkd3d_proton.sh

## download and install steamcmd
cd /tmp
curl -sSL -o steamcmd.tar.gz http://media.steampowered.com/installer/steamcmd_linux.tar.gz
mkdir -p /mnt/server/.steam/steamcmd
tar -xzvf steamcmd.tar.gz -C /mnt/server/.steam/steamcmd
cd /mnt/server/.steam/steamcmd

## needs to be used for steamcmd to operate correctly
chown -R root:root /mnt
export HOME=/mnt/server

## install game using steamcmd
mkdir -p /mnt/server/fs22
./steamcmd.sh +force_install_dir /mnt/server/fs22 +login ${STEAM_USER} ${STEAM_PASS} ${STEAM_AUTH} +@sSteamCmdForcePlatformType windows +app_update ${SRCDS_APPID} ${INSTALL_FLAGS} +quit ## other flags may be needed depending on install. looking at you cs 1.6

# set up 32 bit libraries
mkdir -p /mnt/server/.steam/sdk32
cp -v linux32/steamclient.so /mnt/server/.steam/sdk32/steamclient.so

# set up 64 bit libraries
mkdir -p /mnt/server/.steam/sdk64
cp -v linux64/steamclient.so /mnt/server/.steam/sdk64/steamclient.so

git clone https://github.com/DoJoMan18/fs22_ptero.git ./temp
cp -r ./temp/rootfs/. /mnt/server/
chmod +x /mnt/server/start.sh
rm -rf ./temp

chown -R root:root /mnt

# Setting default variables
if [ -n "${HTTP_PORT}" ]; then
    sed -i "s/    listen 80;/    listen ${HTTP_PORT};/" /mnt/server/.nginx/nginx/conf.d/default.conf
fi

if [ -n "${ADM_PASS}" ]; then
    sed -i "s/<passphrase>webpassword<\/passphrase>/<passphrase>${ADM_PASS}<\/passphrase>/" /mnt/server/steamapps/fs22/dedicatedServer.xml
    sed -i "s/<admin_password><\/admin_password>/<admin_password>${ADM_PASS}<\/admin_password>/" "/mnt/server/My Games/FarmingSimulator2022/dedicated_server/dedicatedServerConfig.xml"
fi

if [ -n "${SERVER_PORT}" ]; then
    sed -i "s/<port>10823<\/port>/<port>${SERVER_PORT}<\/port>/" "/mnt/server/My Games/FarmingSimulator2022/dedicated_server/dedicatedServerConfig.xml"
fi