#!/bin/bash

dryrun=no
if [  "$1" = "-n" -o "$1" = "--dry-run" ]
then
  dryrun=yes
fi

if [ $dryrun = no ]; then
  echo "Potential uploads:"
  find-mapillary-sequences.sh
fi

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
  if [ "`find "$d/" -iname '*.jpg' | wc -l`" = "0" ]
  then
    upload=no
  fi

  if [ $upload = yes ]
  then
    if [ $dryrun = no ]; then
      mapillary_upload.sh "$d"
    else
      echo "$d"
    fi
  fi
done

