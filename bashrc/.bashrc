# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# Unlimited bash history
HISTSIZE=
HISTFILESIZE=
HISTCONTROL=ignoreboth:erasedups # Ignore lines starting with a space, ignore and delete duplicate entries
HISTTIMEFORMAT='[%F %T]  '
HISTIGNORE="history"

bind '"\e[A": history-search-backward'	# Search backward through history for completion
bind '"\e[B": history-search-forward'	# Search forward through history for completion

# User specific aliases and functions
alias pg='ps aux | grep $(echo $1 | sed "s/^\(.\)/[\1]/g")'

if [ -f ~/.bashrc.$HOSTNAME ]; then
        . ~/.bashrc.$HOSTNAME
fi
