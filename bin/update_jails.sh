#! /bin/bash

jails=(plex sonarr radarr syncing jackett manage webserv)

for jail in "${jails[@]}"; do

    echo "#####################"
    echo "Updating jail $jail"
    echo "#####################"

    iocage pkg $jail update
    iocage pkg $jail upgrade -y
    iocage pkg $jail clean -y
    iocage pkg $jail autoremove -y

    iocage restart -s $jail

done;