#!/bin/bash
# Hardcode $PATH, primarily for debian
# https://security.stackexchange.com/a/117548
PATH=~/bin:~/.local/bin:/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin

# Check for an interactive session
[ -z "$PS1" ] && return

# Define some colors first:
red='\033[0;31m'
#RED='\033[1;31m'
blue='\033[0;34m'
#BLUE='\033[1;34m'
green='\033[0;32m'
cyan='\033[0;36m'
#CYAN='\033[1;36m'
NC='\033[0m'              # No Color

declare PROMPT_COMMAND="history -a;$PROMPT_COMMAND" # Insta-update the history like zsh
export HISTFILESIZE=300000    # save 300000 commands
export HISTCONTROL=ignoreboth:erasedups    # no duplicate lines in the history.
export HISTSIZE=100000
export CLICOLOR=1 # Enable colorized ls on FreeBSD

shopt -s checkwinsize

export EDITOR=emacs
export PAGER='less -R'

# Turn off system mail checking
shopt -u mailwarn
unset MAILCHECK

# Turn the useless Ctrl-s/Ctrl-q commands off
stty stop undef
stty start undef

# Stop debian from telling me what command I meant to use
unset command_not_found_handle

if [ -e .bashrc_aliases ]; then
  . .bashrc_aliases
fi

if [ -e .bashrc_functions ]; then
  . .bashrc_functions
fi

if ! pgrep -u "$UID" ssh-agent > /dev/null; then
  ssh-agent > ~/.ssh-agent-thing
fi
if [[ "$SSH_AGENT_PID" == "" && -e ~/.ssh-agent-thing ]]; then
  eval $(< ~/.ssh-agent-thing)
fi
ssh-add -l >/dev/null || alias ssh='ssh-add -l >/dev/null || ssh-add && unalias ssh; ssh'

# For FreeBSD
[[ -f /usr/local/share/bash-completion/bash_completion.sh ]] && \
  source /usr/local/share/bash-completion/bash_completion.sh

PS1="\[$red\]"'\h'"\[$NC\]"':'"\[$green\]"'\W'"\[$NC\]"'\['"$blue"'\]$(git_prompt)'"\[$NC\]"' \$ ' # the git_prompt function is in the .bashrc_functions file

# Activate homeshick if available
if [[ -e "$HOME/.homesick/repos/homeshick/homeshick.sh" ]]; then
  source "$HOME/.homesick/repos/homeshick/homeshick.sh"
  source "$HOME/.homesick/repos/homeshick/completions/homeshick-completion.bash"
  homeshick --quiet --batch --force refresh
fi

if [[ -e /usr/local/etc/advanced-shell-history/config ]]; then
  source /usr/local/etc/advanced-shell-history/config
  source /usr/local/lib/advanced_shell_history/sh/bash
fi

if [[ -s "$HOME/.rvm/scripts/rvm" ]]; then
  source "$HOME/.rvm/scripts/rvm"
  export PATH="$PATH:$HOME/.rvm/bin"
fi

if [[ -e /etc/lsb-relase ]]; then
  if ! hash -r emacs && hash -r zile; then
    alias emacs=zile
  fi
fi

if [[ -n "$TMUX" ]]; then
  export TERM='screen-256color'
elif [[ -e /usr/share/terminfo/x/xterm-256color || \
        -e /lib/terminfo/x/xterm-256color || \
        -e /opt/local/share/terminfo/78/xterm-256color ]]; then # OS X
  export TERM='xterm-256color'
else
  export TERM='xterm-color'
fi

if hash go 2>/dev/null; then
  export GOPATH=$HOME/go
  export PATH="$PATH:$GOPATH/bin"
fi

if [[ -d "${KREW_ROOT:-$HOME/.krew}/bin" ]]; then
  export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
fi

if [[ -s "$HOME/.nvm/nvm.sh" ]]; then
  export NVM_DIR="$HOME/.nvm"
  source "$NVM_DIR/nvm.sh"
fi

# Import misc config files

if [[ -e "$HOME/.bash.d" ]]; then
  for f in "$HOME"/.bash.d/*; do
    . "$f"
  done
fi

echo -ne "$cyan$(hostname)$NC - "
echo -ne "$red"; uname -smr
echo -ne "$blue"; date
echo -ne "$NC"
if [ -x /usr/games/fortune ]; then
  /usr/games/fortune -s     # makes our day a bit more fun
elif [ -x /usr/bin/fortune ]; then
  /usr/bin/fortune -s
fi

echo -ne $NC
