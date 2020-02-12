#!/bin/sh

if [ "$1" = "-h" -o "$1" = "--help" ]; then
  echo "Usage: $0 [-h] gpxfile [angle][time offset sec]"
  echo
  echo "gpxfile Mandatory. Specify . instead of gpxfile to not geotag."
  echo "angle   the angle in degress to which the camera is pointing. Defaults to 0 if not specified."
  echo "time offset sec  if images are not taken in the current time zone and daylight savings time specify the offset to UTC in seconds."
  echo "                  e.g. if taken in UTC+2 with DST in effect, but the command is run with DST not in effect, i.e. UTC+1"
  echo "                  specify 7200 for 2 hours (2 * 60 * 60)."
  echo "WARNING: A username is hard coded inside this script. This must be altered before use or upload will fail!"
  echo 
  exit 0
fi

imageDir=.
username=tryl
gpxfile="$1"
angle="$2"
offset="$3"

if [ ! -e "$gpxfile" ]; then
  echo "The given GPX file '$gpxfile' does not exist."
  exit 1
fi

if [ "$offset" = "" ]; then
  offset="--local_time"
else
  offset="--offset_time $offset"
fi

if [ "$angle" = "" ]; then
  angle="0"
fi

#mkdir -p "$imageDir"

#exiftool -overwrite_original '-createdate>alldates' *.mp4

#mapillary_tools sample_video --import_path "$imageDir" --video_import_path "." --video_sample_interval 0.3 --advanced
if [ "$gpxfile" = "." ]; then
  mapillary_tools process --verbose --advanced --import_path "$imageDir" --user_name "$username" $offset --duplicate_distance 2 --interpolate_directions --offset_angle "$angle" \
   --cutoff_distance 150 --cutoff_time 600 --summarize --save_as_json --rerun
else
  mapillary_tools process --verbose --advanced --import_path "$imageDir" --user_name "$username" $offset --duplicate_distance 2 --interpolate_directions --offset_angle "$angle" \
   --geotag_source "gpx" --geotag_source_path "$gpxfile" --cutoff_distance 150 --cutoff_time 600 --summarize --save_as_json --rerun
fi

