#!/usr/bin/env bash
trim() {
  local s2 s="$*"
  until s2="${s#[[:space:]]}"; [ "$s2" = "$s" ]; do s="$s2"; done
  until s2="${s%[[:space:]]}"; [ "$s2" = "$s" ]; do s="$s2"; done
  echo "$s"
}

. /etc/os-release
_ds_DISTRONAME=$NAME
source <(curl -s https://shell.lunarlabs.cc/asset/acidmotd.sh)
curl -sL https://shell.lunarlabs.cc/services > /tmp/lunar_services

echo "LunarShell ($(basename $SHELL) on ${_ds_DISTRONAME^} ($(uname -s)) $(uname -r))"

printf "\n"
curl --silent https://shell.lunarlabs.cc/ascii.name
bash_motd --banner --processor --memory --swap --diskspace --login
