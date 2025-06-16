#!/bin/bash

if [ $# -eq 0 ];
then
  echo "$0: Missing directory to videos as the first argument"
  exit 1
fi

allVideoFiles=$(find "$1" -name "*.mp4")

# Change IFS to new line
defaultIFS=$IFS
IFS=$'\n'

for videoFile in $allVideoFiles; do
  echo "$videoFile"

  trackCreateDate=$(exiftool -TrackCreateDate -s3 "$videoFile") # This date is in UTC
  trackCreateDateInCentralTimeZone=$(date -jf "%Y:%m:%d %H:%M:%S %z" "$trackCreateDate +0000" +"%Y:%m:%d %H:%M:%S-05:00")

  # Restore 'Create' and 'Modify' date to original taken timestamp
  exiftool "-FileCreateDate=$trackCreateDateInCentralTimeZone" "$videoFile"
  exiftool "-FileModifyDate=$trackCreateDateInCentralTimeZone" "$videoFile"
  
  isHevcEncoded=$(exiftool "$videoFile" | egrep 'Compressor[[:space:]]{1,}ID[[:space:]]{1,}:[[:space:]]{1,}hvc1')
  
  # Transcode video files taken with HEVC(H.265) to H.264
  if [ -n "$isHevcEncoded" ]
  then
    fileName=$(basename -s .mp4 "$videoFile")
    extension="${videoFile##*.}"
    directory=$(dirname "$videoFile")

    ffmpeg -i "$videoFile" -c:v libx264 -crf 16 -c:a aac -map_metadata 0 "${directory}/${fileName}_out.${extension}"
    
    echo "****************************"
    echo "***** Sleep 15 seconds *****"
    echo "****************************"
    sleep 15
  fi
done

# Change IFS back to default
IFS=$defaultIFS
