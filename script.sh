#!/bin/bash

if [ $# -eq 0 ];
then
  echo "$0: Missing directory to videos as the first argument"
  exit 1
fi

allVideoFiles=$(find "$1" -name "*.mp4")
allPixelVideoFiles=$(find "$1" -name "PXL*.mp4")

# Change IFS to new line
defaultIFS=$IFS
IFS=$'\n'

# Restore 'Create' and 'Modify' date to original taken timestamp
for videoFile in $allVideoFiles; do
  exiftool "-FileCreateDate<TrackCreateDate" "$videoFile"
  exiftool "-FileModifyDate<TrackCreateDate" "$videoFile"
done

# Transcode Pixel videos taken with HVEC(H.265) to H.264
for videoFile in $allPixelVideoFiles; do
  fileName=$(basename -s .mp4 "$videoFile")
  extension="${videoFile##*.}"
  directory=$(dirname "$videoFile")

  ffmpeg -i "$videoFile" -c:v libx264 -crf 16 -c:a aac -map_metadata 0 "${directory}/${fileName}_out.${extension}"
  
  echo "*****************************"
  echo "**** Sleeping 15 seconds ****"
  echo "*****************************"
  sleep 15
done

# Change IFS back to default
IFS=$defaultIFS
