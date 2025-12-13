[ -f "$HOME/.cargo/env" ] && source "$HOME/.cargo/env"
[ -f "$HOME/.ghcup/env" ] && source "$HOME/.ghcup/env"

# Add Rust binaries to path
PATH=$PATH:"$HOME/.rustup/toolchains/stable-x86_64-unknown-linux-gnu/bin"
PATH=$PATH:"$HOME/.rustup/toolchains/stable-aarch64-apple-darwin/bin"
PATH=$PATH:"$HOME/.cargo/bin"
PATH=$PATH:"$HOME/go/bin"
PATH="/home/rudi/.dotnet:$PATH"
PATH="/home/rudi/.dotnet/tools:$PATH"
PATH="$HOME/.claude/local:$PATH"

# Add flyctl to path
FLYCTL_INSTALL="/home/rudi/.fly"
PATH="$FLYCTL_INSTALL/bin:$PATH"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Try nushell and fish
if [[ $- == *i* ]]; then
    if [ -x "$(which fish)" ]; then
        exec fish
    fi

    if [ -x "$(which nu)" ]; then
        exec nu
    fi
fi

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

alias claude="/home/rudi/.claude/local/claude"
