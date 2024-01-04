export ZSH=$HOME/.oh-my-zsh
export GIT_EDITOR=vim
export EDITOR=vim
ZSH_THEME="robbyrussell"

plugins=(git)

source $ZSH/oh-my-zsh.sh

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
