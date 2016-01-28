#!/bin/sh

find -type d -name .qiv-trash | while read d
do
  mkdir -p removed
  mv -v "$d/"* removed
  rmdir "$d"
done

