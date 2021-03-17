#!/bin/bash

amixer -c 0 -- sset 'Master' -5dB
amixer -c 0 -- sset 'Headphone' -5dB
amixer -c 0 -- sset 'Speaker' -5dB
amixer -c 0 -- sset 'PCM' -5dB
amixer -c 0 -- sset 'Mic Boost' 0dB
amixer -c 0 -- sset 'Internal Mic Boost' 0dB
amixer -c 0 -- sset 'Capture' 2dB
amixer -c 0 -- sset 'Digital' 22dB
amixer -c 0 -- sset 'Beep' -6dB

## I tried Capture and Digital 0, 22 dB respectively. I suggest probably decreasing the capture to -1 and increasing the Digital to 25. Increasing the catpure above 0 increases the air noise.

##For Thinkpad T500, I used to record at Capture=2dB  and Digital=22dB

amixer -c 0 -- sset 'Auto-Mute Mode' Disabled
amixer -c 0 -- sset 'Dock Mic Boost' 0dB

## unit step of only 10dB; no finer
amixer -c 0 -- sset 'Internal Mic Boost' 0dB

#############################

killall cairo-compmgr
killall unagi
unagi &

MODE="1280x720"
xrandr --newmode "$MODE" 74.50 1280 1344 1472 1664 720 723 728 748 -hsync +vsync

# xrandr --addmode LVDS1 "$MODE"
# xrandr --addmode VGA1  "$MODE"
# xrandr --output LVDS1 --mode "$MODE" --output VGA1 --mode "$MODE"

# xrandr --addmode HDMI-2 "$MODE"
# xrandr --addmode eDP-1  "$MODE"
# xrandr --output  eDP-1 --mode "$MODE" --output HDMI-2 --mode "$MODE"

xrandr --addmode HDMI1 "$MODE"
xrandr --addmode eDP1  "$MODE"
xrandr --output  eDP1 --mode "$MODE" --output HDMI1 --mode "$MODE"

## Two versions of gromit-mpx:
/usr/local/bin/gromit-mpx-CustomPen & ##for the arrow pen version (which I compiled myself)
## gromit-mpx & ##for the AUR new version which I could define the pen.
guvcview --device=/dev/video2 --profile=/home/wyousef/guvcviewLecutreNotes.gpfl &
simplescreenrecorder &

#scriptdir=$(dirname $0)
# emacs  --visit=/home/wyousef/MyDocuments/Teaching/FCIH/Courses/PatternRecognition/LectureNotes/LectureNotes-PatternRecognition.pdf \
#        --visit=/home/wyousef/MyDocuments/Teaching/FCIH/Courses/Optimization/LectureNotes/LectureNotes-Optimization.pdf \
#        --visit=/home/wyousef/tmp/empty \
#        --load=~/MyDocuments/MyScripts/init.el &
emacs  --visit=/home/wyousef/MyDocuments/Teaching/FCIH/Courses/DataScience/LectureNotes/LectureNotes-DataScience.pdf \
       --visit=/home/wyousef/tmp/empty \
       --load=~/MyDocuments/MyScripts/init.el &


