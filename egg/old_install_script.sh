#!/bin/bash
# The wine generic server installer
# This will just pull a download link and unpack it in directory if specified.

# Variables:
# STEAM_USER - Steam username
# STEAM_PASS - Steam password
# STEAM_AUTH - Steam Auth code
# SRCDS_APPID - Steam APP ID
# INSTALL_FLAGS - Custom flags
# SERVER_EXECUTABLE - Excute server

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

apt update -y
apt install -y curl file unzip libcurl4:i386 libcurl4 libstdc++6 ca-certificates git libsdl2-mixer-2.0-0 libsdl2-image-2.0-0 libsdl2-2.0-0 winbind openjdk-11-jdk

if [ ! -d /mnt/server ]; then
    mkdir -p /mnt/server/
fi

if [ ! -d /mnt/server/games ]; then
    mkdir -p /mnt/server/games/
fi


## download and install steamcmd
cd /tmp
curl -sSL -o steamcmd.tar.gz http://media.steampowered.com/installer/steamcmd_linux.tar.gz
mkdir -p /mnt/server/steamcmd
tar -xzvf steamcmd.tar.gz -C /mnt/server/steamcmd
cd /mnt/server/steamcmd

## needs to be used for steamcmd to operate correctly
chown -R root:root /mnt
export HOME=/mnt/server

## install game using steamcmd
./steamcmd.sh +force_install_dir /mnt/server +login ${STEAM_USER} ${STEAM_PASS} ${STEAM_AUTH} +@sSteamCmdForcePlatformType windows +app_update ${SRCDS_APPID} ${INSTALL_FLAGS} +quit ## other flags may be needed depending on install. looking at you cs 1.6

# set up 32 bit libraries
mkdir -p /mnt/server/.steam/sdk32
cp -v linux32/steamclient.so /mnt/server/.steam/sdk32/steamclient.so

# set up 64 bit libraries
mkdir -p /mnt/server/.steam/sdk64
cp -v linux64/steamclient.so /mnt/server/.steam/sdk64/steamclient.so