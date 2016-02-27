#!/bin/sh

find-mapillary-sequences.sh | while read s
do
  if [ -f "$s/track.gpx" ]
  then
    rm -v "$s/track.gpx"
  fi
  mv -v "$s"/* .
  rmdir "$s"
done

if [ -d duplicates ]
then
  mv -v duplicates/* .
  rmdir duplicates
fi

