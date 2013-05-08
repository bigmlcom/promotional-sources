#!/bin/bash

if [ -z "$BIGML_USERNAME" ] || [ -z "$BIGML_API_KEY" ] || [ -z "$BIGML_AUTH" ]; then
    echo "BigML credentials needs to be set in the environment"
    exit 1
fi

cat - << EOF
#############
## WARNING ##
#############

This script will completely purge ALL SOURCES (not just the promotional sources)
from the "$BIGML_USERNAME" account. Are you sure?
EOF

read -p "Are you sure [y/n]? " -n 1
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    echo 
    echo "Whew! Close one"
    exit 1
fi

IO=bigml.io

echo 

for source in `curl -k "https://$IO/andromeda/source?limit=1000;$BIGML_AUTH" 2>/dev/null | python -m json.tool | grep resource | cut -d '"' -f4`; do 
    echo "deleting $source"
    curl -k -X "DELETE" https://$IO/$source?$BIGML_AUTH; 
done

for source in `curl -k "https://$IO/dev/andromeda/source?limit=1000;$BIGML_AUTH" 2>/dev/null | python -m json.tool | grep resource | cut -d '"' -f4`; do 
    echo "deleting $source"
    curl -k -X "DELETE" https://$IO/dev/$source?$BIGML_AUTH; 
done
