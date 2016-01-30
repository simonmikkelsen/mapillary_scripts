#!/bin/bash
# http://api.mapillary.com/v1/u/uploadhashes

dircount="`find "$1" -type d | wc -l`"

if [ "$dircount" != "1" ]; then
  echo "Dir count is not 1 but $dircount for '$1'."
  echo "This prevents you from accidentially uploading folders that contains e.g. removed images."
  exit
fi

source "$HOME/.mapillary_scripts"
if [ -z "$MAPILLARY_ROOT" ]; then
  echo "MAPILLARY_ROOT must be defined with a non empty value in ~/.mapillary_scripts"
  echo "See the README.md file."
  exit 1
fi

export "MAPILLARY_SIGNATURE_HASH=$MAPILLARY_SIGNATURE_HASH"
export "MAPILLARY_PERMISSION_HASH=$MAPILLARY_PERMISSION_HASH"
export "MAPILLARY_USERNAME=$MAPILLARY_USERNAME"

echo "Uploading '$1'..."
yes | python "$MAPILLARY_ROOT/mapillary_tools/python/upload_with_authentication.py" "$1" | tee -a "$1/log-upload.txt"
echo

