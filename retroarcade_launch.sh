#!/bin/sh
cd "$HOME/retroarcade-data" || exit 1
exec cage -s "$HOME/retroarcade/target/release/retroarcade"
