alias mountdrive="rclone mount drive: rclone/Google\ Drive/ --vfs-cache-mode full --daemon"
alias mountdocs="rclone mount docs: rclone/Documents/ --vfs-cache-mode full --daemon"
alias mpv="flatpak run io.mpv.Mpv"

eval "$(starship init bash)"
