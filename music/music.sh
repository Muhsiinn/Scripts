#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# Path to the file containing URLs
URL_FILE="urls.txt"

# Check if the file exists
if [[ ! -f "$URL_FILE" ]]; then
    echo "Error: '$URL_FILE' not found!"
    exit 1
fi

# Check if mpv is installed
if ! command -v mpv &>/dev/null; then
    echo "Error: 'mpv' is not installed! Please install it and try again."
    exit 1
fi

# Read all non-empty lines into an array (prepare for shuffling)
mapfile -t URLs < <(grep -Ev '^\s*$' "$URL_FILE")

# Verify we actually have some URLs
if (( ${#URLs[@]} == 0 )); then
    echo "Error: No valid URLs found in '$URL_FILE'!"
    exit 1
fi

# Shuffle the list of URLs randomly
mapfile -t shuffled_URLs < <(shuf -e "${URLs[@]}")

# Play each URL (audio only, using PulseAudio)
for url in "${shuffled_URLs[@]}"; do
    echo "Now playing: $url"
    mpv --no-video \
        --ao=pulse \
        "$url"
        #--ytdl-format=bestaudio \
        #--ytdl-raw-options=sub-lang=en \
        #--sub-auto=all \
        #--slang=en
done

echo "▶ Playback finished!"
