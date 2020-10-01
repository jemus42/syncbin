#!/bin/bash
# Source: http://blog.roberthallam.org/2018/04/quick-hacks-a-script-to-extract-a-single-image-frame-from-video/
# f.sh - single frame

USAGE="f.sh infile timecode [outfile]"

if [ "$#" == "0" ]; then
        echo "$USAGE"
        exit 1
fi

if [ -e "$1" ]; then
        video="$1"
else
        echo "file not found: $1"
        exit 1
fi

if [ ! -z "$2" ]; then
        time="$2"
else
        echo "Need timecode!"
        exit 1
fi

if [ ! -z "$3" ]; then
        outfile="$3"
else
        echo "Need out file!"
        exit 1
fi



echo "ffmpeg -i \"$video\" -ss $time  -vframes 1 -f image2 \"$outfile\""

ffmpeg -loglevel quiet -hide_banner -ss $time -i "$video" -vframes 1 -vf "scale=720:-2" -f image2 "$outfile"

# ffmpeg -loglevel quiet -hide_banner -ss $time -i "$video" -vframes 1 -vf "scale=1080:-2" -f image2 "$outfile"

# Generically maintain aspect ratio, but doesn't quite fit
# ffmpeg -loglevel quiet -hide_banner -ss $time -i "$video" -vframes 1 -vf "scale=640:trunc(ow/a/2)*2" -f image2 "$outfile"
