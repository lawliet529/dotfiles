#!/bin/sh

yt-dlp -f ba --remux-video ogg --embed-metadata -o "%(playlist)s/%(playlist_index)s %(title)s.%(ext)s" $@
