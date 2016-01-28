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
Detailed description of the scripts. They can be run without arguments or `-h `to see what arguments they require.

find-mapillary-sequences.sh
---------------------------
Finds all folders named only with 1-3 numbers, which is the format the sequence splitter script uses.

flatten-folder.sh
-----------------
Renames files in sub folders, so all files are in a single structure. If a files path is `FOLDER_001/FILE_001.jpg` it will be named `FOLDER_001_FILE_001.jpg`.

gpx.fmt
-------
Used internally by `reverse-geotagging.sh`

.mapillary_scripts
------------------
Template that must be filled out and put in the users home directory (`~/`). This is the configuration file for the scripts.

mapillary_upload.sh
-------------------
Uploads a given sequence without asking for credentials.

mv-removed.sh
-------------
Finds all folders named `.qiv-trash` (created by the Quick Image Viewer qiv) and puts their contents in a folder named `removed`.

mv-successfull-files.sh
-----------------------
If upload is done using `prepare.sh` a file named log-upload.txt is produced. All files which are listed as uploaded in this log file will be moved to the given destination.
Note: The script does not take into account if a sequence upload was aborted - only individual files that e.g. timed out.

prepare.sh
----------
Runs the steps as described earlier. Takes two arguments:
1. The direction relative to the movement the camera is pointting. E.g. 0 for forward facing, -180 or 180 for backward, -90 for full left facing, 45 for partial right etc.
2. The path to a gpx file for geotagging the files.

remove-slow-shutters.sh
-----------------------
Moves images with shutter speed less than a certain value.
Note that e.g. my Garmin Virb Elete tags all images as having 1/15 sec shutter speed, even though it is wrong.
Usually 50 is a good value for walking while 100 - 150 is minimum for bicycle and car.

reverse-geotagging.sh
---------------------
Creates a gpx file from a folder of geotagged images. In this way you can geotag cameras with the location data created by another camera.

show-upload-status.sh
---------------------
Finds all `log-upload.txt` files and presents a summary of how it is going.

sleep-mapillary-upload.sh
-------------------------
Sleeps untill the currently running `mapillary-upload.sh` script has finished.

upload_unfinished_seqnences.sh
------------------------------
Uploads all sequences that does not contain a file named 'log-upload.txt`. The script does not analyze the file (you are welcome to write that).

Todo
====
In the current state the following needs to be done for the script to be easy to use for others:
* prepare.sh and others requires mapillary_tools to be located in the same folder as the script.
* Folders that contains the name garmin will not be geotagged - this should be a switch instead.
* Scripts may require scripts which are only on my computer.
* Split sequences and remove duplicates uses hard coded values.
* Reverse geotagging should be optional.
