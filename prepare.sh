#!/bin/bash

source ~/.mapillary_scripts
scriptDir="$MAPILLARY_ROOT"

deg="$1"
shift
if [ "$deg" = "" -o "$deg" = "-h" ]
then
  echo "Usage: $0 offset_degrees [gpxfile]"
  exit
fi

if [[ ! $deg =~ ^-?[0-9]+$ ]]
then
  echo "The given degrees must be an integer."
  exit 1
fi

if [ "$1" != "" ]; then
  gpxfile="$1"
  if [ ! -f "$gpxfile" ]; then
    echo "'The given '$gpxfile' does not exist."
    exit
  fi
fi

seqCount="`find-mapillary-sequences.sh | wc -l`"
if [ "$seqCount" = "0" ]; then
  echo "Flatten folder"
  flatten-folder.sh | tee log-flatten-folder.txt | tail -n5

  # Should output nothing.
  grep -v ' -> ' log-flatten-folder.txt
fi

if [[ ! "$PWD" =~ "/garmin" ]]; then
  echo "Geotag"
  exiftool -ignoreMinorErrors -overwrite_original -geotag "$gpxfile" . 2>&1 | tee log-geotag.txt | tail -n10
  
  echo "Interpolate direction"
  python "$scriptDir/mapillary_tools/python/interpolate_direction.py" . $deg  | tee log-interpolate-direction.txt | tail -n5

  # Should output nothing.
  grep -v 'Added direction to:' log-interpolate-direction.txt
fi

if [ "$seqCount" = "0" ]; then
  echo "Sequence split"
  python "$scriptDir/mapillary_tools/python/sequence_split.py" . 120 100 | tee log-sequence-split.txt | tail -n5
fi

echo "Remove duplicates"
find-mapillary-sequences.sh | while read d
do
  python "$scriptDir/mapillary_tools/python/remove_duplicates.py" -d 1.7 "$d/" | tee -a log-remove-duplicates.txt | tail -n2
done
# Should output nothing.
grep -v ' => ' log-remove-duplicates.txt 
echo "Duplicates: `grep ' => ' log-remove-duplicates.txt | wc -l` of total `find -iname '*.jpg' | wc -l` images."

echo "Create gpx for each sequence"
find-mapillary-sequences.sh | while read d
do
  echo "Reverse geotag '$d'" >> log-reverse-geotagging.txt
  reverse-geotagging.sh "$d" "$d/track.gpx" 2>&1 | tee -a log-reverse-geotagging.txt | tail -n5
done

echo "Done"
echo "$deg degrees" > prepared.txt

