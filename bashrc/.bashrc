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
alias unlock-datenknecht='ssh -i ~/.ssh/dropbear_key -p 2222 -o "HostKeyAlgorithms ssh-ed25519" root@192.168.178.54'
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

export GOPATH=$HOME/go/:$HOME/Projects/
export DEVKITPRO="/opt/devkitpro"
export DEVKITARM="/opt/devkitpro/devkitARM"
export DEVKITPPC="/opt/devkitpro/devkitPPC"
