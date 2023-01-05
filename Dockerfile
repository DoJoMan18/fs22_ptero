# ---------------------------------------
# Generic Wine image based on Wine stable 
# ---------------------------------------
FROM    ghcr.io/parkervcp/yolks:debian

LABEL   author="DoJoMan18" maintainer="fs22-ptero@dakinspecteurs.nl"

## install required packages
RUN     dpkg --add-architecture i386 \
    && apt update -y \
    && apt install -y --install-recommends locales locales-all gnupg2 tzdata software-properties-common libntlm0 winbind xvfb xauth python3 libncurses5:i386 libncurses6:i386 nginx curl file \
    unzip libcurl4:i386 libcurl4 libstdc++6 ca-certificates git libsdl2-mixer-2.0-0 libsdl2-image-2.0-0 libsdl2-2.0-0 winbind openjdk-11-jdk mesa-vulkan-drivers:i386
# Default locale
RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && \
    locale-gen

ENV LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8

# Install winehq-stable and with recommends
# RUN     wget -nc https://dl.winehq.org/wine-builds/winehq.key \
#     && apt-key add winehq.key \
#     && echo "deb https://dl.winehq.org/wine-builds/debian/ bullseye main" >> /etc/apt/sources.list \
#     && wget -O- -q download.opensuse.org/repositories/Emulators:/Wine:/Debian/Debian_11/Release.key | apt-key add - \
#     && echo "deb http://download.opensuse.org/repositories/Emulators:/Wine:/Debian/Debian_11 ./" | tee /etc/apt/sources.list.d/wine-obs.list \
#     && apt update \
#     && apt install -y --install-recommends winehq-staging cabextract winbind xvfb
RUN mkdir -pm755 /etc/apt/keyrings \
    && wget -O /etc/apt/keyrings/winehq-archive.key https://dl.winehq.org/wine-builds/winehq.key \
    && wget -NP /etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/debian/dists/bullseye/winehq-bullseye.sources \
    && apt update \
    && apt install -y --install-recommends winehq-staging cabextract winbind xvfb

# Set up Winetricks
RUN	    wget -q -O /usr/sbin/winetricks https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks \
    && chmod +x /usr/sbin/winetricks

# Setting up env and finishing code
ENV     HOME=/home/container
# ENV     WINEARCH="win64"
ENV     WINEDEBUG=+gdiplus
ENV     WINEPREFIX=/home/container/.wine
ENV     WINEDLLOVERRIDES="dxgi=n,mscoree,mshtml="
ENV     DISPLAY=:0
ENV     DISPLAY_WIDTH=1024
ENV     DISPLAY_HEIGHT=768
ENV     DISPLAY_DEPTH=16
ENV     AUTO_UPDATE=1
ENV     XVFB=1

USER    container
WORKDIR	/home/container

# Setting default shit
COPY ./entrypoint.sh /entrypoint.sh
CMD ["/bin/bash", "/entrypoint.sh"]