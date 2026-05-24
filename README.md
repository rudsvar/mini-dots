# mini-dots

Shared dotfiles for all machines. Tracked with a bare git repo at `~/.cfg`.

## Setup

```bash
git clone --bare git@github.com:rudsvar/mini-dots.git "$HOME/.cfg"
git --git-dir="$HOME/.cfg" --work-tree="$HOME" checkout
```

Add to fish config:

```fish
alias conf="git --git-dir=$HOME/.cfg --work-tree=$HOME"
```

## What's tracked

Shell, editor, and terminal config shared across machines. Machine-specific files (services, SSH keys, host-specific config) live in separate per-machine repos.
