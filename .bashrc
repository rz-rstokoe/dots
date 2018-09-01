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
    if [[ $brinfo =~ ("[ahead "([[0-9]]*)]) ]]
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
PATH="${PATH}:~/bin:~/.cargo/bin:."

set -o vi

# use exa instead of ls
alias ls='exa'
alias ll='exa -l'
alias la='exa -la'
alias wat='echo "dunno man"'
alias okay='echo yes'
alias k='okay'
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

function cinit {
    mkcd $1 && cat <<EOF >Makefile && vim a.c
CFLAGS=-Wall -g

default: a

clean:
	rm a
EOF
}

function rbinit {
    mkcd $1 && vim a.rb
}

latex_make_path=~/usr/projects/latex-make/Makefile

function newtex {
    case $# in
        1)
            file=$1
            dir=$1
            title="Title"
            ;;
        2)
            file=$1
            dir=$2
            title="Title"
            ;;
        3)
            file=$1
            dir=$2
            title=$3
            ;;
        *)
            echo "usage $0 filename [directory] [title] "
            ;;
    esac

    mkcd $dir && cp $latex_make_path ./ && [[ ! -e ${file}.tex ]] && cat <<EOF >${file}.tex && vim ${file}.tex || echo "${file}.tex exists"
\documentclass[12pt,letterpaper]{article}

\title{$title}
\author{Robby Stokoe}
\date{\today}

\begin{document}
\maketitle

\end{document}
EOF
}

function tlmgr {
    tllocalmgr $*
    echo done
}

function bye {
    drive=$(mount |grep cifs)
    if [[ !($? == 1) ]] # 0 if found, 1 if not, 2 if error
    then
        drive=$(echo $drive |awk '{print $3}')
        echo "Unmount $drive"
    else
        echo 'Shutting down'
        shutdown now
    fi
}

rust_book_ref_path=~/usr/ref/rust-book/second-edition/book/
rust_book_work_path=~/usr/projects/rust/book

# open rust book
# This gets the last git tag in the repo, adds zeros with sed if necessary,
# figures out the index of the file in the book directory corresponding to the
# tag (with grep), adds one to it with awk, and chooses that file with sed to
# open that one in firefox.
# This will probably break when I get to double-digit chapters
# Now 100% more-readable with outlined variables
function orb {
    cd $rust_book_work_path && \
    ( # in subshell so we can do set -e
    set -e
    previous_chapter=$(git tag |tail -1 \
        | sed 's/ch\([1-9]\)\.\([1-9]\)/ch0\1-0\2/')
    file_index=$(grep --line-number $previous_chapter <(ls $rust_book_ref_path)\
        | awk -F: '{print $1+1}')
    current_chapter=$(sed -n "${file_index}p" <(ls $rust_book_ref_path))
    firefox ${rust_book_ref_path}${current_chapter} &
    )
}
