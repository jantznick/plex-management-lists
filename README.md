# plex-management-lists
Repo of scripts for help in managing my plex server and automated downloading

### scan-library.sh
Scans a plex library compared to a previous snapshot of files in the library. Useful for when your media library is in an NFS mount or similar where the plex library auto scan on new files function doesn't work

### remove-completed-torrents.sh
Checks a transmission API endpoint and removes finished torrents from the list of active torrents while retaining local data. Should be run from the above script for maximum cleanliness of transmissions active torrents
