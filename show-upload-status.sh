#!/bin/sh

find -name 'log-upload.txt' | sort -n | while read f
do
  echo "`grep 'Success: ' $f | grep -v "Success: DONE" | wc -l` of `find $(dirname $f) -iname '*.jpg' | wc -l` in $f"
done

