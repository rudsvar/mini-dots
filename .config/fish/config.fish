alias conf="git --git-dir=$HOME/.cfg --work-tree=$HOME"

set -x EDITOR nvim
set -x VISUAL $EDITOR 
set -x JDTLS_JVM_ARGS "-javaagent:$HOME/Downloads/lombok.jar"
set uname (uname)
set -x COMPOSE_BAKE true

if command -sq starship
    starship init fish | source
end

if status is-interactive
and not set -q TMUX
and command -sq tmux
and [ "$uname" = "Darwin" -o "$DISPLAY" != "" ]
and [ "$TERM_PROGRAM" != "vscode" ]
and [ "$TERMINAL_EMULATOR" != "JetBrains-JediTerm" ]
    exec tmux new-session -A -t main
end

if test -e todo.md
    cat todo.md
end

if command -sq erd
    alias tree erd
end

if command -sq exa
    alias ls exa
end

if command -sq direnv
    direnv hook fish | source
end

function cx
    set DIR (fd . --type d | fzf --height 50% --reverse)
    if test -n "$DIR"
        cd $DIR
    end
end

function cg
    set DIRS (fd . "$HOME/git" --type d)
    set GIT_DIRS ""
    for DIR in $DIRS
        if test -d $DIR/.git
            set GIT_DIRS "$GIT_DIRS $DIR"
        end
    end
    set GIT_DIR (echo $GIT_DIRS | sed 's/ /\n/g' | fzf --height 50% --reverse)
    if test -n "$GIT_DIR"
        cd $GIT_DIR
    end
end

function kx
    set PROCESS (ps | tail +2 | fzf --height 50% --reverse --header "kill $argv")
    if test -z "$PROCESS"
        return
    end
    set id (echo $PROCESS | awk '{print $1}')
    kill $argv "$id"
end

function kp
    set PROCESS (lsof -i -P -n | tail +2 | fzf --height 50% --reverse --header "kill $argv")
    if test -z "$PROCESS"
        return
    end
    set id (echo $PROCESS | awk '{print $2}')
    kill $argv "$id"
end

alias ex 'fd . --type f | fzf --height 50% --reverse | xargs -r -I {} $EDITOR "{}"'
alias claude="~/.claude/local/claude"
