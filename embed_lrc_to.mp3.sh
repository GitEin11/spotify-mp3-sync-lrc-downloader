#!/bin/bash

# Path to a temporary file for the counter
counter_file=$(mktemp)

# Initialize the counter
echo 0 > "$counter_file"

# This function will embed the .lrc file into the .mp3 file using eyeD3
embed_lyrics() {
    local mp3file="$1"
    local lrcfile="${mp3file%.mp3}.lrc"

    # Remove existing lyrics
    eyeD3 --remove-all-lyrics "$mp3file"

    if [[ -f "$lrcfile" ]]; then
        # Embed the new .lrc file
        eyeD3 --add-lyrics="$lrcfile" "$mp3file"
        # Read the current count, increment it, and write it back
        local count=$(<"$counter_file")
        count=$((count + 1))
        echo "$count" > "$counter_file"
        # Update the terminal title with the current count
        echo -ne "\033]0;Embedded MP3 Count: $count\007"
    fi
}

# Export the function so it can be used by find -exec
export -f embed_lyrics
export counter_file

# Find all .mp3 files and call embed_lyrics on each one
find "$(dirname "$0")" -type f -name '*.mp3' -exec bash -c 'embed_lyrics "$0"' {} \;

# Print the final count
count=$(<"$counter_file")
echo "Total number of MP3 files processed: $count"

# Clean up the temporary file
rm "$counter_file"
