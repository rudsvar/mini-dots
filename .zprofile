[ -f "$HOME/.cargo/env" ] && source "$HOME/.cargo/env"
[ -f "/$HOME/.ghcup/env" ] && source "$HOME/.ghcup/env"
[ -f "/opt/homebrew/bin/brew" ] && eval $(/opt/homebrew/bin/brew shellenv)

PATH=$PATH:"$HOME/.ghcup/bin"

exec fish
