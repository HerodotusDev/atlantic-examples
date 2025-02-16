#!/bin/bash

if [ -z "$1" ]; then
    echo "Usage: $0 <atlantic-query-id>"
    exit 1
fi

URL=$(curl -s "https://staging.atlantic.api.herodotus.cloud/atlantic-query/$1" | jq -r '.metadataUrls' | grep "/proof\.json\"" | tr -d '"')
curl -s $URL -o proof.json
