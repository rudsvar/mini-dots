[ -f "$HOME/.cargo/env" ] && source "$HOME/.cargo/env"
[ -f "$HOME/.ghcup/env" ] && source "$HOME/.ghcup/env"

# Add Rust binaries to path
PATH=$PATH:"$HOME/.rustup/toolchains/stable-x86_64-unknown-linux-gnu/bin"
PATH=$PATH:"$HOME/.rustup/toolchains/stable-aarch64-apple-darwin/bin"
PATH=$PATH:"$HOME/.cargo/bin"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Try nushell and fish
if [ -x "$(which nu)" ]; then
    exec nu
fi

if [ -x "$(which fish)" ]; then
    exec fish
fi
