#!/bin/bash

inputDir="$1"
outputDir="$2"
minSpeed=$3
if [ "$minSpeed" = "" ]; then
  minSpeed=50
fi

if [ ! -d "$inputDir" -o "$outputDir" = "" ]; then
  echo "Usage: $0 inputDir outputDir"
  exit
fi

find "$inputDir" -maxdepth 1 -mindepth 1 -iname '*.jpg' | while read f
do
  shutterSpeed="`exiftool -s3 -ShutterSpeed "$f" | sed 's#1/##g'`"
  if [ "$shutterSpeed" -lt $minSpeed ]
  then
    mkdir -p "$outputDir"
    mv -v "$f" "$outputDir"
  fi
done

