#!/bin/bash

# get error about session id that contains the session id
ERROR=$(curl -s -X POST -H "Content-Type: application/json" -d '{"method":"torrent-get", "arguments":{"fields":["id", "status", "percentDone"]}}' http://localhost:9091/transmission/rpc)

# sed to get the session id between the <code> tags
SESSION_ID=$(echo $ERROR | sed -n 's/.*<code>.*: \(.*\)<\/code>.*/\1/p')

# get all torrents
TORRENTS=$(curl -s -X POST -H "Content-Type: application/json" -H "X-Transmission-Session-Id: $SESSION_ID" -d '{"method":"torrent-get", "arguments":{"fields":["id", "status", "percentDone"]}}' http://localhost:9091/transmission/rpc)

# get list of completed torrents
COMPLETED=$(echo "$TORRENTS" | jq -r '.arguments.torrents[] | select(.status==6) | .id')

# remove completed torrents
for ID in $COMPLETED
do
    # Remove the completed torrents
    REMOVED=$(curl -s -X POST -H "Content-Type: application/json" -H "X-Transmission-Session-Id: $SESSION_ID" -d "{\"method\":\"torrent-remove\", \"arguments\":{\"ids\":[$ID], \"delete-local-data\":false}}" http://localhost:9091/transmission/rpc)
    echo "Deleted torrent ID $ID"
done
