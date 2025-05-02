#!/bin/bash

PLEX_SCAN_URL="https://${plexUrl}/library/sections/2/refresh?X-Plex-Token=${plexToken}"

DIRECTORY_TO_WATCH=
LAST_RUN_FILE="lastrun.txt"
TEMP_FILE="temprun.txt"

# Ensure the last run file exists 
touch $LAST_RUN_FILE

# Find all files in directory and save paths into temp file
find $DIRECTORY_TO_WATCH -type f > $TEMP_FILE

# Compare the temp file with the last run file and report new files
awk 'NR==FNR{x[$0];next} !($0 in x)' $LAST_RUN_FILE $TEMP_FILE > newfiles.txt

if [ -s newfiles.txt ]
then
    echo "New files found:"
    cat newfiles.txt
    # Trigger a Plex scan if a new file is found
    curl "$PLEX_SCAN_URL"
    echo "Scanning Plex for new content..."
fi

# Overwrite the last run file with the temp file for next comparison
mv $TEMP_FILE $LAST_RUN_FILE