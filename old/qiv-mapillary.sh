#!/bin/sh

scriptDir="`dirname "$0"`"

"$scriptDir"/find-mapillary-sequences.sh | while read d
do
  qiv -m "$d"
done

"$scriptDir"/mv-removed.sh

