#!/bin/sh

yt-dlp -f ba -x --embed-metadata -P /tmp/ytm-dlp -o "%(playlist)s/%(playlist_index)s %(title)s.%(ext)s" $@

beet import /tmp/ytm-dlp
