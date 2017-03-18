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
export PS1="[BALC:\w] \\$ "
export PS2='... '

alias emacs="TERM=xterm-256color emacs"

bind "set completion-ignore-case on" # This ignores case in bash completion
bind "set bell-style none" # Turn off bell
bind "set show-all-if-ambiguous On" # Single tab completion
bind Space:magic-space #auto expand ! variants upon space
shopt -s cdspell # correct small spelling errors automagically

if [ ! -z "$TERM" ]; then
    cat ~/.motd
fi
