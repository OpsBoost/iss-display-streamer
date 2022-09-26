# iss-display-streamer
Creates an infoscreen display that can be accessed over the network


## Build container
Uses [swayvnc](https://github.com/bbusse/swayvnc) as base image
```
$ podman build -t iss-display-streamer .
```

## Run container
```
$ podman run -e URL iss-display-streamer
```

## Open stream with media player

mpv/mplayer/vlc tcp://ip:port
```
$ mpv tcp://localhost:6000
```
Default port is 6000, can be overridden by env var PORT
```
