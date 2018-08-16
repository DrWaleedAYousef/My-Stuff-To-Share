#!/bin/bash

######### NeroBackItUp-LIKE for Linux #########
# Created By: Waleed A. Yousef, Ph.D.

# Version: 1.0

# Date: May., 30, 2015.

#Regular incremental rsync backup, which does not keep history; only the latest backup is kept.
######################################################

SRC="/home/wyousef"
DST="/mnt/MyPassportLinux/MyRsyncBackup"

# OPT="-avh --delete --exclude-from=MyExcludeFile.txt"
#The --exclude-from option: directories should be wyousef/DIR if it is /DIR then any directory of that name at any level will be execluded not only at the root of the transfer directory.
OPT="-aXSvh --delete" 
### to check exact copying: sudo diff -r SRC DST
sudo rsync $OPT --log-file="$DST/LogFile.txt" "$SRC" "$DST"

