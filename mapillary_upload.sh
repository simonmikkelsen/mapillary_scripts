#!/bin/sh
# http://api.mapillary.com/v1/u/uploadhashes

dircount="`find "$1" -type d | wc -l`"

if [ "$dircount" != "1" ]; then
  echo "Dir count is not 1 but $dircount for '$1'."
  echo "This prevents you from accidentially uploading folders that contains e.g. removed images."
  exit
fi

scriptDir="`dirname "$0"`"

source ~/.mapillary_scripts

echo "Uploading '$1'..."
yes | python "$MAPILLARY_ROOT/mapillary_tools/python/upload_with_authentication.py" "$1" | tee -a "$1/log-upload.txt"
echo

