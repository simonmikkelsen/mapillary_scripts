#!/bin/sh

file="$1"

location="`exiftool -GPSPosition -s -s -s -n "$file"`"
if [ -z "$location" ]
then
  echo "No location in file."
  exit 
fi

lat="`echo "$location" | cut -d " " -f 1`"
lon="`echo "$location" | cut -d " " -f 2`"
url="http://www.openstreetmap.org/?mlat=$lat&mlon=$lon#map=18/$lat/$lon"
xdg-open "$url"
xdg-open "$file"

