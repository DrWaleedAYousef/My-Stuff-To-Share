#!/bin/bash
 timestamp="$(date +%Y-%m-%d--%H.%M.%S)"
 targetbase="$HOME/Downloads/AAMyDocumentsAA/capscr"
 mkdir -p $targetbase
 [ -d $targetbase ] || exit 1
 import -window root $targetbase/$timestamp.png
 
