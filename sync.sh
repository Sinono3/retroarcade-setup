#!/bin/sh
target="$1"

[ -z "$target" ] && echo "Provide an SSH directory target: user@host:/path/to/directory" && exit 1

rsync -urltv -e 'ssh' . "$target"
