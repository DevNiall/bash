# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

PS1="\[\e[1;37m\][\u@\h \W]\$ \[\e[m\]" #WHITE PROMPT

# Unlimited bash history
HISTSIZE=
HISTFILESIZE=
HISTCONTROL=ignoreboth:erasedups # Ignore lines starting with a space, ignore and delete duplicate entries
HISTTIMEFORMAT='[%F %T]  '
HISTIGNORE="history"

# Prevent different sessions overwriting bash_history
# http://briancarper.net/blog/248/
PROMPT_COMMAND="history -a; history -n; $PROMPT_COMMAND"
shopt -s histappend

#setxkbmap -model evdev -layout gb

youtube_viewer(){
        mplayer -really-quiet $(youtube-dl -g $1)
}

# If interactive shell then...
if [[ $- == *i* ]]; then
  bind '"\e[A": history-search-backward'  # Search backward through history for completion
  bind '"\e[B": history-search-forward'   # Search forward through history for completion
fi

# User specific aliases and functions
alias pg='ps aux | grep $(echo $1 | sed "s/^\(.\)/[\1]/g")'

if [ -f ~/.bashrc.$HOSTNAME ]; then
    . ~/.bashrc.$HOSTNAME
fi
