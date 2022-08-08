#! /bin/bash

#jails=(plex sonarr syncing manage webserv)
jails=$(iocage list | awk '{print $4}' | awk NF | grep -v NAME)

for jail in $jails; do # "${jails[@]}"; do

    echo "#####################"
    echo "Updating jail $jail"
    echo "#####################"

    iocage pkg $jail update -f
    iocage pkg $jail upgrade -y
    iocage pkg $jail clean -y
    iocage pkg $jail autoremove -y

    # iocage restart -s $jail

done;

# iocage restart plex
# iocage restart sonarr
