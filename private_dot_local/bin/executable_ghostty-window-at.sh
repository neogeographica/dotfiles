#!/usr/bin/env zsh
wd=$1
osascript <<EOF
tell application "Ghostty"
    set cfg to new surface configuration
    set initial working directory of cfg to "$wd"
    set win to new window with configuration cfg
end tell
EOF
