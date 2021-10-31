#!/bin/bash
######### NeroBackItUp-LIKE for Linux #########
# Created By: Waleed A. Yousef, Ph.D.

# Version: 1.0

# Date: Feb., 17, 2015.

# Description: This script is the seed of a NeroBackItUp-LIKE SW for Linux users. It aims at
# creating unlimed amount of incremental daily backups (more than once a day) while keeping all the
# incremental previous versions.

#Precondition: the only preconditions is that the contents of the destination directory of the
#backup (defined below as $DST) is not modified except by this script or by someone know exactly
#what this script does. Otherwise, the behaviour is unexpected.

#Future features: checking for directory stamps to avoid unintentional structure modification, DVD
#backup, ...etc.
###############################################


### follow the symlinks that point to original files and backup these files to local HD first.
cd /home/wyousef/MyDocuments/MyScripts/InstallationTipsArch
for f in $(find -type l); do
    cp -H $f CP-H-Symlink/
done
cd ~
########
### Then, backup entire HD to external

SCRIPTDIR=$(dirname $0)
SRC="/home/wyousef"
DST="/mnt/MyPassportLinux/MyNeroBackItUp"
OPT="-avh --delete --exclude-from=$SCRIPTDIR/MyExcludeFile.txt" #options for full backup and part of the
						     #options for inc backup.
echo $OPT

#The --exclude-from option: directories should be wyousef/DIR if it is /DIR then any directory of
#that name at any level will be execluded not only at the root of the transfer directory.

if ! [ -d "$DST" ]; then
    mkdir "$DST"
    echo "I created the directory "$DST" and will use it or this and future backups"
fi

Today=`date -I`
LastBackup=`ls "$DST" | sort -r | head -n 1` #the most recent inc backup day

if  [ -z "$LastBackup" ]; then #$DST is empty directory; hence do full backup
    TRG="$DST/$Today/1"
    mkdir -p "$TRG"
    sudo rsync $OPT --log-file="$TRG/LogFile.txt" "$SRC" "$TRG"

elif [[ "$Today" > "$LastBackup" ]]; then #Today's backup does not exist yet.
    LastBackupInc=`ls "$DST/$LastBackup" | sort -r | head -n 1`
    TRG="$DST/$Today/1"
    mkdir -p "$TRG"
    sudo rsync $OPT --log-file="$TRG/LogFile.txt" --link-dest="$DST/$LastBackup/$LastBackupInc" "$SRC" "$TRG"

elif [[ "$Today" = "$LastBackup" ]]; then #Today's directory is the most recent.
    LastBackupInc=`ls "$DST/$Today" | sort -r | head -n 1`
    TRG="$DST/$Today/$((LastBackupInc+1))"
    mkdir -p "$TRG"
    sudo rsync $OPT --log-file="$TRG/LogFile.txt" --link-dest="$DST/$LastBackup/$LastBackupInc" "$SRC" "$TRG"

else echo "Today's date: $Today happens before the last backup's date: $LastBackup !!; I will terminate..........UNSUCCESSFUL BACKUP....CHECK YOUR DATES..."
fi

#Warning: when I tried to concatenate the original option (OPT) with the new Incremental option
#(--link-dest=.....), something wrong happened!! rsync kept backing up from strange sources!!

