# Process Video Files For Synology Photos

The script takes in a path as the first argument where the video files that need processing are saved. Make sure to enclose the path with quotation marks.

```
./script.sh "/path/to/directory"
```

Before running the script, you might need to assign executable permissions `chmod +x script.sh`.

The script changes the default IFS to a new line (`\n`) character, then at the end it restores the original IFS. This is because inside a `for` loop, if the directory path has spaces, the terminal will split the path string into multiple lines, thus, creating an invalid path. By changing the IFS to a new line character, the splitting will happen at the end of the string.

The first step is to get the original taken timestamp which is in UTC, then convert this timestamp into Central Time.

After we have the timestamp in Central Time, copy into the "created" and "modified" metadata using the [exiftool](https://exiftool.org/) tool.

The second step is to transcode video files taken with HEVC (H.265) encoding to H.264 since Synology Photos cannot play or index videos encoded with HEVC. For this step, the script uses [ffmpeg](https://ffmpeg.org/) tool.

The transcoded video file will have the same name as the original file, but with `_out` string appended at the end and it will be created in the same directory as the original video file.

### Note Related to Converting UTC Timestamp to CT

Change `-05:00` to your timezone at the end of the below conversion.

```
trackCreateDateInCentralTimeZone=$(date -jf "%Y:%m:%d %H:%M:%S %z" "$trackCreateDate +0000" +"%Y:%m:%d %H:%M:%S-05:00")
```

## Giving Back

If you find this repo useful in any way, consider getting me a coffee by clicking on the image below. I would really appreciate it!

[![Buy Me A Coffee](https://www.buymeacoffee.com/assets/img/custom_images/black_img.png)](https://www.buymeacoffee.com/esausilva)

-Esau
