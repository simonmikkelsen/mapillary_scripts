#!/bin/sh

# Run from the DCIM folder of a Garmin Virb 
find . -iname "*.jpg" | xargs rename "_VIRB/VIRB" "Virb"
