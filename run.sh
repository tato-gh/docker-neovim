#!/bin/sh

## create dev user and set uid of the /srv which is develop root directory
UID=`ls -1dl /srv |sed 's/[\t ]\+/\t/g' |cut -f3`
GID=`ls -1dl /srv |sed 's/[\t ]\+/\t/g' |cut -f4`
chown $UID:$GID /home/dev -R
adduser dev -D -u $UID -h /home/dev

sudo -i -u dev byobu
