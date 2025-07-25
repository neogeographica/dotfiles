#!/usr/bin/env zsh

ONEPWD_EXE="/opt/1Password/1password"
if ! [[ -x "$ONEPWD_EXE" ]]
then
  echo
  echo "*** WARNING no executable found at $ONEPWD_EXE"
  echo "*** .config/autostart/1password-silent.desktop will fail."
  echo "*** Also, without 1Password running, some ssh key management will fail."
  echo
fi
