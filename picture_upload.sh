#!/bin/sh

path=images/mapillary_sampled_video_frames/

if [ "$1" != "" ]
then
  path="$1"
fi

mapillary_tools upload --advanced --verbose --import_path "$path" --number_threads 4 --summarize --save_as_json  --verbose  --move_sequences --move_uploaded --move_duplicates 
#--save_local_mapping
#--skip_subfolders

