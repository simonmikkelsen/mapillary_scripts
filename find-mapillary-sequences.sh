#!/bin/sh

if [ "$1" != "" ]; then
  folder="$1"
else
  folder="."
fi

find "$folder" -type d -name '[0-9]' -or -name '[0-9][0-9]' -or -name '[0-9][0-9][0-9]' | egrep -v 'done|removed'  | sort -n

