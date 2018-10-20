#!/bin/sh

exiftool -recurse -dateFormat %Y%m%d '-directory<createdate' '-filename<${createdate#;DateFmt("%H_%M_%S")}_${filename}' -ext jpg .

