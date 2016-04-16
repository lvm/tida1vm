# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
fi

if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

export LANG=C.UTF-8
export HOME=/home/tidal
export PATH=$PATH:$HOME/bin
export TERM=xterm-256color
export PS1="\[\e[37;40m\][\[\e[m\]\[\e[31;40m\]tida1vm\[\e[m\]\[\e[37;40m\]:\[\e[m\]\[\e[37;40m\]\w\[\e[m\]\[\e[37;40m\]]\[\e[m\]\[\e[37;40m\] \[\e[m\]\[\e[37;40m\]\\$\[\e[m\]\[\e[37;40m\] \[\e[m\] "
export PS2='... '

alias emacs="TERM=xterm-256color emacs"

[ -f $HOME/.bash_profile ] && source $HOME/.bash_profile
