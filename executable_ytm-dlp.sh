#!/bin/bash

yt-dlp -f ba --remux-video ogg --embed-metadata -P $HOME/Music -o "%(playlist)s/%(playlist_index)s %(title)s.%(ext)s" $@

beet import $HOME/Music/
