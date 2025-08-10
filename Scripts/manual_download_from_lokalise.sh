#!/bin/zsh

# Install the Lokalise command line tools from https://github.com/lokalise/lokalise-cli-2-go
# Generate an API Token (not an SDK Token!) following the instructions here: https://docs.lokalise.com/en/articles/1929556-api-tokens
# export LOKALISE_TOKEN="<yourtokenhere>"

set -e
set -u

: "$LOKALISE_TOKEN"

date=`date`

# Fetch translations from Lokalise
rm -rf xliff_in
lokalise2 \
    --token "$LOKALISE_TOKEN" \
    --project-id "414338966417c70d7055e2.75119857" \
    file download \
    --format xliff \
    --bundle-structure "%LANG_ISO%.%FORMAT%" \
    --original-filenames=false \
    --placeholder-format ios \
    --export-empty-as skip \
    --replace-breaks=false \
    --unzip-to ./xliff_in
