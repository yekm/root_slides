#!/bin/bash

# example
# find pictures -type f | egrep -i -e репин -e кандинский | shuf | DISPLAY=:0 bash root_slides.sh

# deps
#pacman -S xorg-server xorg-xinit xorg-apps ffmpeg graphicsmagick xdotool some-font

# useful
# systemctl start xlogin@yekm
# sudo systemctl stop kodi
# DISPLAY=:0 xset s off -dpms

set -vxue

# 3840 x 2160 4k tv
dim=$(xdpyinfo | awk '/dimensions:/ { print $2; exit }')
read w h <<< $(echo $dim | tr x ' ')
xdotool mousemove $w $h

bmp=$(mktemp "/tmp/XXX-$0.bmp")
txt=$(mktemp "/tmp/XXX-$0.txt")
trap 'rm -v $bmp $txt' EXIT

delay=$1

#find "$@" -type f | shuf | while read pic; do
while read pic; do

    # last two components of the file's path
    echo "$pic" | rev | cut -f1-2 -d/ | rev | tr '/' '\n' >$txt
    # TODO add exiv2 info?

    # resize to screen with lanczos, pad to center with black, add text
    ffmpeg -nostdin -loglevel error -i "$pic" \
        -vf "scale=$dim:flags=lanczos:force_original_aspect_ratio=1, \
            pad=x=-1:y=-1:width=$w:height=$h:color=black, \
            drawtext=textfile=$txt:fontcolor=0xffffffaa:shadowx=2:shadowy=2:fontsize=75:x=13:y=13" \
        -y $bmp || continue

    # this suckless software sucks
    # -f does not work properly
    #sxiv -g $dim -f $bmp

    # imagegrapthicksfuckingmagick cant into utf8 text
    #gm convert "$pic" \
    #    -gravity center -background black -filter Lanczos -resize $dim -extent $dim \
    #    -gravity southwest -fill "#ff08" -pointsize 100 -font DejaVu-Sans-Bold label:"'$text'" \
    #    $bmp
    #  -draw "text 0,0 '$text'" \

    # on my tv this is pixel perfect
    gm display -window root $bmp

    sleep $delay
done

