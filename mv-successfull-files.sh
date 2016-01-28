#!/bin/sh

dest="$1"
if [ "$dest" = "" ]; then
  echo "Usage: $0 destination_dir"
  exit 1
fi

find -name log-upload.txt | while read f
do
  dir="`dirname "$f"`"
  grep -v 'Success: DONE' "$f"  | grep Success | sed 's/^Success: //g' | while read file
  do
    mkdir -p "$dest/$dir"
    mv -v "$dir/$file" "$dest/$dir/"
  done
done
