#!/bin/sh

find -maxdepth 1 -mindepth 1 -type d | while read d; do find $d -maxdepth 1 -mindepth 1 -type f | while read f; do fn="`basename "$f"`"; mv -v $d/$fn ${d}_$fn;  done; rmdir $d; done

