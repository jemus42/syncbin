#! /bin/bash

users=(plex sonarr radarr syncthing resilio jackett emby)

for user in "${users[@]}"; do

  pw groupadd ppth
  pw group mod ppth -m $user

done