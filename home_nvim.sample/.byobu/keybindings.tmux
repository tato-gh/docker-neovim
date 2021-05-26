unbind-key -n C-a
unbind-key -n C-q
set -g prefix ^Q
set -g prefix2 F12
bind q send-prefix
bind-key g command-prompt "select-window -t %1"
