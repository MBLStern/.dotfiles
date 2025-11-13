#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias ll='ls -l'
alias la='ls -la'
alias grep='grep --color=auto'
alias ..='../'
alias ...='../../'
alias ....='../../../'
alias .....='../../../../'
alias cp='cp -vi'
alias mv='mv -vi'
alias wget-uni='wget --user=q2046296 --ask-password'
alias get-idf='. /opt/esp-idf/export.sh'
PS1='[\u@\h \W]\$ '
fstr() {
    grep -Rnw "." -e "$1"
}
sudolast() {
    if [[ $# == 0 ]]; then
        sudo $(history -p '!!')
    else
        sudo "$@"
    fi
}
export PATH=/usr/local/texlive/2013/bin/x86_64-linux:$PATH
export MANPATH=/usr/local/texlive/2013/texmf-dist/doc/man:$MANPATH
export INFOPATH=/usr/local/texlive/2013/texmf-dist/doc/info:$INFOPATH
