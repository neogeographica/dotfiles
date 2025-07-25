#!/usr/bin/env zsh

if which wezterm &> /dev/null
then
  true
else
  echo
  echo "*** WARNING no wezterm executable found in PATH."
  echo "*** .local/share/applications/org.wezfurlong.wezterm.desktop will fail."
  echo
fi