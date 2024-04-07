#!/bin/sh

# Sort applications by name
gsettings set org.gnome.shell app-picker-layout "[]"

# Disable gestures for XWayland apps (wine apps crash on multitouch gestures)
xinput list --name-only | grep ^xwayland-pointer-gestures | xargs -n1 xinput disable
