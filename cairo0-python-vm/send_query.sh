#!/bin/bash

if [ -z "$1" ]; then
    echo "Usage: $0 <api_key>"
    exit 1
fi

curl --request POST \
    --url https://staging.atlantic.api.herodotus.cloud/atlantic-query?apiKey=$1 \
    --header 'Content-Type: multipart/form-data' \
    --form layout=auto \
    --form cairoVm=python \
    --form 'programFile=@compiled.json' \
    --form 'inputFile=@input.json' \
    --form cairoVersion=cairo0 \
    --form result=PROOF_VERIFICATION_ON_L2 \
    --form mockFactHash=false
