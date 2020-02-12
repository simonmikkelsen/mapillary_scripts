#!/bin/bash

source "$HOME/.mapillary_scripts"
scriptDir="$MAPILLARY_ROOT"
timeshiftfile=timeshift.txt

deg="$1"
shift

skipDirection=false
if [ "$1" = "--skip-direction" ]; then
  skipDirection=true
  shift
fi

skipDuplicates=false
if [  "$1" = "--skip-duplicates" ]; then
  skipDuplicates=true
  shift
fi

timeshift=0
if [ "$1" = "--timeshift" ]; then
  shift
  timeshift="$1"
  shift
fi

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

gpxfile=""
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

if [ "$gpxfile" != "" ]; then
  echo "Geotag"
  if  [ -f  "$timeshiftfile" ]; then
    # Handle timeshift. If first timestamp in the gpx file is e.g. 8:00 and the first images is stamped 9.00,
    # the timeshift.txt must contain only a 1. In the reverse case -1 can be used.
    timeshift="`cat "$timeshiftfile"`"
  fi
  timeoffset=""
  timeoffsetfile=timeoffset.txt
  if [ -f "$timeoffsetfile" ]; then
    #timeoffset="--time-offset `cat "$timeoffsetfile"`"
    echo Skip timeoffset
  fi
  # If timeoffset file is specified use the Mapillary script. If not, use exiftool for backward compatibillity..
  if [ -n "$timeoffset" ]; then
    python "$scriptDir/mapillary_tools/python/geotag_from_gpx.py" $timeoffset . "$gpxfile"
   else
    #exiftool -ignoreMinorErrors -overwrite_original -globaltimeshift "$timeshift" -geosync="$timeshift" -geotag "$gpxfile" . 2>&1 | tee log-geotag.txt | tail -n10
    exiftool -ignoreMinorErrors -overwrite_original "-Geotime<DateTimeOriginal#" -geosync="$timeshift" -geotag "$gpxfile" . 2>&1 | tee log-geotag.txt | tail -n10
  fi
  
  if [ $skipDirection != true ]; then
    echo "Interpolate direction"
    python "$scriptDir/mapillary_tools/python/interpolate_direction.py" . $deg  | tee log-interpolate-direction.txt | tail -n5 2>&1 | tee log-geotag.txt | tail -n10

    # Should output nothing.
    grep -v 'Added direction to:' log-interpolate-direction.txt
  fi
fi

if [ "$seqCount" = "0" ]; then
  echo "Sequence split"
  python "$scriptDir/mapillary_tools/python/sequence_split.py" . 120 300 | tee log-sequence-split.txt | tail -n5
fi

if [ $skipDuplicates != true ]; then
  echo "Remove duplicates"
  find-mapillary-sequences.sh | while read d
  do
    python "$scriptDir/mapillary_tools/python/remove_duplicates.py" -d 1.7 "$d/" | tee -a log-remove-duplicates.txt | tail -n2
  done
  # Should output nothing.
  grep -v ' => ' log-remove-duplicates.txt 
  echo "Duplicates: `grep ' => ' log-remove-duplicates.txt | wc -l` of total `find -iname '*.jpg' | wc -l` images."
fi

echo "Create gpx for each sequence"
find-mapillary-sequences.sh | while read d
do
  echo "Reverse geotag '$d'" >> log-reverse-geotagging.txt
  reverse-geotagging.sh "$d" "$d/track.gpx" 2>&1 | tee -a log-reverse-geotagging.txt | tail -n5
done

echo "Done"
echo "$deg degrees" > prepared.txt

