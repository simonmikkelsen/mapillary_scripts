#!/bin/sh

find-mapillary-sequences.sh | while read d; do find "$d" -iname '*.jpg' ; done | wc -l

