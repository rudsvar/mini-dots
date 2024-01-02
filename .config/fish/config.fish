cd $HOME

alias conf="git --git-dir=$HOME/git/mini-dots.git --work-tree=$HOME"

set -x EDITOR nvim
set -x VISUAL $EDITOR 

starship init fish | source

if status is-interactive
and not set -q TMUX
and command -sq tmux
    exec tmux
end
