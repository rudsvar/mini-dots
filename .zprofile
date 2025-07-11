[ -f "$HOME/.cargo/env" ] && source "$HOME/.cargo/env"
[ -f "/$HOME/.ghcup/env" ] && source "$HOME/.ghcup/env"
[ -f "/opt/homebrew/bin/brew" ] && eval $(/opt/homebrew/bin/brew shellenv)

PATH=$PATH:"$HOME/.ghcup/bin"
PATH=$PATH:"$HOME/go/bin"
alias claude="~/.claude/local/claude"

# Try nushell and fish
if [[ $- == *i* ]]; then
    if [ -x "$(which fish)" ]; then
        exec fish
    fi

    if [ -x "$(which nu)" ]; then
        exec nu
    fi
fi
