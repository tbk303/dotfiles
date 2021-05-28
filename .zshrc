# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="tbk"

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Comment this out to disable weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
#COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git git-extras rails ruby rbenv bundler)

source $ZSH/oh-my-zsh.sh

if [[ "${TERM}" == "rxvt-unicode" ]] ; then
    export TERMTYPE="256"
elif [[ "${TERM}" != "dumb" ]] ; then
    export TERMTYPE="16"
else
    export TERMTYPE=""
    export NOCOLOR="true"
fi

if [[ "${TERM}" == "rxvt-unicode" ]] && \
    [[ ! -f /usr/share/terminfo/r/rxvt-unicode ]] && \
    [[ ! -f ~/.terminfo/r/rxvt-unicode ]] ; then
    export TERM=rxvt
fi

export BROWSER="chromium-browser"
export TERMCMD="urxvtc"
export EDITOR="vim"
export OOO_FORCE_DESKTOP=gnome

# Fix Java apps in xmonad
export _JAVA_AWT_WM_NONREPARENTING=1

export ANDROID_HOME="/home/tbk/Android/Sdk"

# Aliases
alias ll="ls -lh --color=auto"
alias la="ls -lha --color=auto"
alias diff=colordiff
alias grep="grep --color=auto"
alias remind="remind -b1 -m"
alias ssh='ssh-add -l || ssh-add && ssh'

if [[ -n "${PATH/*$HOME\/bin:*}" ]] ; then
    export PATH="$HOME/bin:$PATH"
fi

if [[ -n "${PATH/*\/usr\/local\/bin:*}" ]] ; then
    export PATH="/usr/local/bin:$PATH"
fi

if [[ -n "${PATH/*$HOME\/.cabal\/bin:*}" ]] ; then
    export PATH="$HOME/.cabal/bin:$PATH"
fi

if [[ -n "${PATH/*$HOME\/.local\/bin:*}" ]] ; then
    export PATH="$HOME/.local/bin:$PATH"
fi


# Load autojump
. /usr/share/autojump/autojump.sh

PATH=$HOME/.rbenv/bin:$PATH


### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"

export NVM_DIR="/home/tbk/.nvm"
#[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
alias nvm-enable=". $NVM_DIR/nvm.sh"

alias dc="docker-compose"

alias vim=nvim

eval "$(rbenv init -)"


[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
