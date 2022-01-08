#!/bin/bash

mkdir /media/movies
mkdir /media/tv
mkdir /media/downloads
mkdir /config
chown -R 1000:1000 /media
chown -R 1000:1000 /config

echo "Starting plex containers..."
docker container run -d \
    --name plex-media-server \
    --net=host \
    --restart=unless-stopped \
    -v /config:/config \
    -v /media/movies:/movies \
    -v /media/tv:/tv \
    linuxserver/plex