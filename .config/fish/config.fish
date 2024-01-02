alias conf="git --git-dir=$HOME/.cfg --work-tree=$HOME"

set -x EDITOR nvim
set -x VISUAL $EDITOR 

starship init fish | source

if status is-interactive
and not set -q TMUX
and command -sq tmux
and [ "$TERM_PROGRAM" != "vscode" ]
and [ "$TERMINAL_EMULATOR" != "JetBrains-JediTerm" ]
    exec tmux new-session -A -t main
end

if test -e todo.md
    cat todo.md
end

if command -sq et
    alias tree et
end

if command -sq exa
    alias ls exa
end

alias cx 'cd (fd . --type d | fzf --height 50% --reverse)'
alias ex 'fd . --type f | fzf --height 50% --reverse | xargs -r -I {} $EDITOR "{}"'
