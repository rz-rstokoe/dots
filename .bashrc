# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=10000
HISTFILESIZE=80000
# git prompt
# inspired by https://bytebaker.com/2012/01/09/show-git-information-in-your-prompt/

function git-branch-name {
    echo $(git symbolic-ref HEAD 2>/dev/null |awk -F/ {'print $NF'})
}

function git-dirty {
    st=$(git status 2>/dev/null |tail -n 1)
    if [[ $st != 'nothing to commit, working tree clean' ]]
    then
        echo '*'
    fi
}

function git-unpushed {
    brinfo=$(git branch -v |grep $(git-branch-name))
    if [[ $brinfo =~ (\[ahead ([0-9]+)\]) ]]
    then
        echo "${BASH_REMATCH[2]}"
    fi
}

function gitify {
    branch=$(git-branch-name)
    if [[ $branch != '' ]]
    then
        echo "($branch$(git-dirty)$(git-unpushed))"
    fi
}

PS1='[\u@\h \W]$(gitify)\$ '
PATH="${PATH}:$(ruby -e 'puts Gem.user_dir')/bin:$HOME/bin"

set -o vi

# make tabs the proper width
tabs -4
LESS='x4'
# this breaks git paging, so fix that
GIT_PAGER='less -FRX'

alias psme="ps -fu $USER"
alias ss='scrot -s ~/usr/img/scrot/%F_%T.png'
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias pacman='pacman --color=auto'
alias wim='vim -c "set nonu spell"'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -la'
alias l='ls -CF'

# list running docker containers
alias lscontainers="docker container ls --format '{{.Names}}'"

# use special command for tracking configuration files
# from: https://developer.atlassian.com/blog/2016/02/best-way-to-store-dotfiles-git-bare-repo/
alias config='/usr/bin/git --git-dir=$HOME/.cfg --work-tree=$HOME'

# disable beeps
alias less='less -Q'
alias man='man -P "less -Q"'

function mkcd {
    mkdir -p $1 && cd $1
}

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi
source /usr/share/google-cloud-sdk/completion.bash.inc
source ~/monorepo/zlaverse/support/bash_functions.sh
export COMPOSE_FILE=./docker-compose.yml:./docker-compose-linux.yml
