#!/bin/sh
user="arcadex"
rsync -urltv -e 'ssh -p 3022' . "${user}@127.0.0.1:/home/${user}/retroarcade-setup"
