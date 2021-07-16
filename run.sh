#!/bin/sh

## create nvim user and set uid of the /srv which is project root directory
UID=`ls -1dl /srv |sed 's/[\t ]\+/\t/g' |cut -f3`
GID=`ls -1dl /srv |sed 's/[\t ]\+/\t/g' |cut -f4`
chown $UID:$GID /home/nvim -R
adduser nvim -D -u $UID -h /home/nvim --shell /bin/bash

VIM_PLUG=/home/nvim/.local/share/nvim/site/autoload/plug.vim
if [ ! -e $VIM_PLUG  ]; then
  sudo -i -u nvim curl -fLo /home/nvim/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi;

# TMUX_PLUG=/home/nvim/.tmux/plugins/tpm
# if [ ! -e $TMUX_PLUG  ]; then
#   sudo -u nvim git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
# fi;

sudo -i -u nvim byobu
