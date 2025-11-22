#!/bin/sh
printf '\033c\033]0;%s\a' Moonshot
base_path="$(dirname "$(realpath "$0")")"
"$base_path/moonshot.x86_64" "$@"
