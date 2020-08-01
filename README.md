# Lidarr

Simple docker image for Lidarr without any bloat, built on the official mono image. Lidarr runs as user `lidarr` with `uid` and `gid` `1000` and listens on port `8686`.

## Usage

```sh
docker run --rm ghudiczius/lidarr:<VERSION> \
  -p 8686:8686 \
  -v path/to/config:/config \
  -v path/to/downloads:/downloads \
  -v path/to/music:/music
```
