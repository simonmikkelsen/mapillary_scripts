#!/bin/sh

if [ "$1" = "-h" -o "$1" = "--help" ]; then
  echo "Usage: $0 [-h] gpxfile [angle]"
  echo "WARNING: A username is hard coded in this script. It must be changed or the upload will fail!"
  exit 0
fi

imageDir=images
username=tryl
gpxfile="$1"
angle="$2"

if [ ! -f "$gpxfile" ]; then
  echo "The given GPX file '$gpxfile' does not exist."
  exit 1
fi

if [ "$angle" = "" ]; then
  angle="0"
fi

mkdir -p "$imageDir"

#exiftool -overwrite_original '-createdate>alldates' *.mp4

#mapillary_tools sample_video --import_path "$imageDir" --video_import_path "." --video_sample_interval 0.3 --advanced
mapillary_tools process --verbose --advanced --import_path "$imageDir" --user_name "$username" --duplicate_distance 2 --interpolate_directions --offset_angle "$angle" \
 --local_time --geotag_source "gpx" --geotag_source_path "$gpxfile" --cutoff_distance 30 --cutoff_time 600 --summarize --save_as_json --rerun

