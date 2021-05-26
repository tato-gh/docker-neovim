#!/bin/sh

## create nvim user and set uid of the /srv which is project root directory
UID=`ls -1dl /srv |sed 's/[\t ]\+/\t/g' |cut -f3`
GID=`ls -1dl /srv |sed 's/[\t ]\+/\t/g' |cut -f4`
chown $UID:$GID /home/nvim -R
adduser nvim -D -u $UID -h /home/nvim --shell /bin/bash

sudo -i -u nvim byobu
