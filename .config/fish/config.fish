alias conf="git --git-dir=$HOME/git/mini-dots.git --work-tree=$HOME"

set -x EDITOR nvim
set -x VISUAL $EDITOR 

starship init fish | source
source $HOME/.ghcup/env
source $HOME/.cargo/env
