#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

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
PATH="${PATH}:$(ruby -e 'puts Gem.user_dir')/bin"

set -o vi

# make tabs the proper width
tabs -4
LESS='x4'
# this breaks git paging, so fix that
GIT_PAGER='less -FRX'

alias psme="ps -fu $USER"
alias ss='scrot -s ~/usr/img/scrot/%F_%T.png'
alias grep='grep --color=auto'
alias pacman='pacman --color=auto'
alias wim='vim -c "set nonu spell"'
# use special command for tracking configuration files
# from: https://developer.atlassian.com/blog/2016/02/best-way-to-store-dotfiles-git-bare-repo/
alias config='/usr/bin/git --git-dir=$HOME/.cfg --work-tree=$HOME'

# disable beeps
alias less='less -Q'
alias man='man -P "less -Q"'

function mkcd {
    mkdir -p $1 && cd $1
}
