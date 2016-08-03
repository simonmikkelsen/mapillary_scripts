#!/bin/bash

echo "Potential uploads:"
find-mapillary-sequences.sh

find-mapillary-sequences.sh | while read d
do
  upload=no
  if [ ! -f "$d/log-upload.txt" ]
  then
    upload=yes
  elif ! grep -q 'Done uploading.' "$d/log-upload.txt"
  then
    upload=yes
  fi

  if [ $upload = yes ]
  then
    mapillary_upload.sh "$d"
  fi
done

