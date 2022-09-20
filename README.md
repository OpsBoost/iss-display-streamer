# sway-streamer
Creates a desktop session video stream


## Build container
Uses [swayvnc](https://github.com/bbusse/swayvnc) as base image
```
$ podman build -t sway-streamer .
```

## Run container
```
$ podman run -e URL -v /dev/shm:/dev/shm -ti sway-streamer
```

## Open stream with media player

mpv/mplayer/vlc tcp://ip:port
```
$ mpv tcp://localhost:6000
```
Default port is 6000, can be overridden by env var PORT
```
