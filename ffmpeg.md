# ffmpeg

## Combine Audio and Video

```
ffmpeg -i video.mp4 -i audio.m4a -map 0:v -map 1:a -c copy -shortest output.mp4
```
