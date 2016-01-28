#!/bin/sh

find-mapillary-sequences.sh | while read d
do
  if [ ! -f $d/log-upload.txt ]
  then
    mapillary_upload.sh $d
  fi
done

