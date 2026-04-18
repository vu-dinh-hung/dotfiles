set -g history-limit 100000
# https://superuser.com/questions/252214/slight-delay-when-switching-modes-in-vim-using-tmux-or-screen/252717
set -s escape-time 10  # this is 10ms by default since tmux 3.5

set -g mouse on

# https://gist.github.com/andersevenrud/015e61af2fd264371032763d4ed965b6
set -g default-terminal "tmux-256color"

# | Key mappings |--------------------------------------------------------------
unbind C-b
set -g prefix C-Space
bind C-b send-prefix  # allow repeated C-Space to still act as prefix key

bind -n M-C-Left previous-window
bind -n M-C-Right next-window
