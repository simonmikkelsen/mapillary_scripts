#!/bin/bash

scriptDir="`dirname "$0"`"

inputDir="$1"
outfile="$2"

if [ ! -d "$inputDir" -o "$outfile" = "" ]; then
  echo "Usage: $0 inputDir outfile"
  exit
fi

gpxfmt="$scriptDir/gpx.fmt"
if [ ! -f "$gpxfmt" ]; then
  print "Missing file: '$gpxfmt'. Get the contents of it from:"
  print "http://www.sno.phy.queensu.ca/~phil/exiftool/geotag.html#GPX"
  print "or just the bottom of this script - note that the # in front of the lines"
  print "must also be part of the file."
  print "Note that the gpsdatetime tag is replaced by datetimeoriginal"
  exit
fi

globaltimeshift=0
if [[ "$inputDir" =~ garmin ]]; then
  globaltimeshift=-1
fi

#exiftool -r -if '$datetimeoriginal' -fileOrder datetimeoriginal -p "$gpxfmt" -d %Y-%m-%dT%H:%M:%SZ "$inputDir" > "$outfile"
exiftool -globaltimeshift $globaltimeshift -ignoreMinorErrors -progress -r -if '$datetimeoriginal' -if '$gpslongitude' -if '$gpslatitude' -fileOrder datetimeoriginal -p "$gpxfmt" -d %Y-%m-%dT%H:%M:%SZ "$inputDir" > "$outfile"




#------------------------------------------------------------------------------
# File:         gpx.fmt
#
# Description:  Example ExifTool print format file for generating GPX track log
#
# Usage:        exiftool -p gpx.fmt -d %Y-%m-%dT%H:%M:%SZ FILE [...] > out.gpx
#
# Requires:     ExifTool version 8.10 or later
#
# Revisions:    2010/02/05 - P. Harvey created
#
# Notes:     1) All input files must contain GPSLatitude and GPSLongitude.
#            2) The -fileOrder option may be used to control the order of the
#               generated track points.
#------------------------------------------------------------------------------
#[HEAD]<?xml version="1.0" encoding="utf-8"?>
#[HEAD]<gpx version="1.0"
#[HEAD] creator="ExifTool $ExifToolVersion"
#[HEAD] xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
#[HEAD] xmlns="http://www.topografix.com/GPX/1/0"
#[HEAD] xsi:schemaLocation="http://www.topografix.com/GPX/1/0 http://www.topografix.com/GPX/1/0/gpx.xsd">
#[HEAD]<trk>
#[HEAD]<number>1</number>
#[HEAD]<trkseg>
#[BODY]<trkpt lat="$gpslatitude#" lon="$gpslongitude#">
#[BODY]  <ele>$gpsaltitude#</ele>
#[BODY]  <time>$datetimeoriginal</time>
#[BODY]</trkpt>
#[TAIL]</trkseg>
#[TAIL]</trk>
#[TAIL]</gpx>
