#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc

export GOPATH=$HOME/go/:$HOME/Projects/
export GOPRIVATE="ssh://git@github.com/MBLStern"
export DEVKITPRO="/opt/devkitpro"
export DEVKITARM="/opt/devkitpro/devkitARM"
export DEVKITPPC="/opt/devkitpro/devkitPPC"
export SVN_EDITOR=/usr/bin/nvim
