Mapillary scripts for multiple action cams
==========================================

When using multiple action cams pointing in multiple directions, there is a lot of processing to do before uploading.
These scripts helps with that.

These scripts are shell scripts, that must be run by a shell like Bash.
Windows users can use cygwin.
You must additionally install exiftool.

What is done
============
The main script, `prepare.sh`, will do the following:
* Flatten all folders, in the case a sequence spans multiple folders.
* Optionally perform geotagging.
* Split images into sequences.
* Remove duplicates.
* Do reverse geotagging of each sequencef or quality assurance.

Scripts
=======
Detailed description of the scripts. They can some times be run without arguments or `-h `to see what arguments they require.

old
---
Folder with script that are outdated, usually for an older Mapillary API.
flatten-folder.sh
-----------------
Renames files in sub folders, so all files are in a single structure. If a files path is `FOLDER_001/FILE_001.jpg` it will be named `FOLDER_001_FILE_001.jpg`.

gpx.fmt
-------
Used internally by `reverse-geotagging.sh`

mv-removed.sh
-------------
Finds all folders named `.qiv-trash` (created by the Quick Image Viewer qiv) and puts their contents in a folder named `removed`.

remove-slow-shutters.sh
-----------------------
Moves images with shutter speed less than a certain value.
Note that e.g. my Garmin Virb Elete tags all images as having 1/15 sec shutter speed, even though it is wrong.
Usually 50 is a good value for walking while 100 - 150 is minimum for bicycle and car.

reverse-geotagging.sh
---------------------
Creates a gpx file from a folder of geotagged images. In this way you can geotag cameras with the location data created by another camera.

show-location.sh
----------------
Given a single image as argument, a browser is opened with an Open Street Map and a marker on the location.
The image is also opened in the default image viewer.

TODO
----
Add proper help switch to new scripts.

pictures_process.sh
-------------------
Runs Mapillary preprocessing on all images in the specified path. Run with -h to read the help with arguments.

picture_upload.sh
-----------------
Uploads the images in the specified folder. Specify . to upload images in the current folder.

video_process.sh
----------------
Runs processing for a set of video files turning them into images that can be uploaded.
Run it with -h to see help.

