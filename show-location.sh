#!/bin/sh

file="$1"

location="`exiftool -GPSPosition -s -s -s -n "$file"`"
lat="`echo "$location" | cut -d " " -f 1`"
lon="`echo "$location" | cut -d " " -f 2`"
url="http://www.openstreetmap.org/?mlat=$lat&mlon=$lon#map=18/$lat/$lon"
google-chrome "$url"
qiv -m "$file"

