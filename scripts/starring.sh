#!/bin/sh

GITHUB_STARS=$(curl -s https://api.github.com/repos/$GITHUB_REPOSITORY | jq -r .stargazers_count)

update_image() {
    GIPHY_RESPONSE=$(curl -s "http://api.giphy.com/v1/gifs/search?q=${2}&api_key=${GIPHY_API_KEY}&limit=1")
    GIPHY_URL=$(echo $GIPHY_RESPONSE | jq -r .data[0].images.downsized.url | cut -d '?' -f1)
    wget -q -O /tmp/giphy.gif $GIPHY_URL
    curl -s -X POST "https://api-content.dropbox.com/2/files/upload" -H "Authorization: Bearer ${DROPBOX_API_KEY}" \
        -H "Content-Type: application/octet-stream" -H "Dropbox-API-Arg: {\"path\": \"/${1}.gif\", \"mode\": \"overwrite\"}" \
        --data-binary @/tmp/giphy.gif 1>/dev/null
}

update_image "giphy1.gif" "$((GITHUB_STARS % 10))"
update_image "giphy2.gif" "$(((GITHUB_STARS / 10) % 10))"
update_image "giphy3.gif" "$(((GITHUB_STARS / 100) % 10))"
