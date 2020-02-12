#!/bin/sh

while ps ax | grep -v ' grep ' | grep -q mapillary_upload.sh ; do sleep 10; done

