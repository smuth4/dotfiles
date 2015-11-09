# Hardcode $PATH, primarily for debian
PATH=/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/sbin:/usr/local/bin

# Check for an interactive session
[ -z "$PS1" ] && return

# Define some colors first:
red='\e[0;31m'
RED='\e[1;31m'
blue='\e[0;34m'
BLUE='\e[1;34m'
cyan='\e[0;36m'
CYAN='\e[1;36m'
NC='\e[0m'              # No Color

export HISTFILESIZE=300000    # save 300000 commands
export HISTCONTROL=ignoredups    # no duplicate lines in the history.
export HISTSIZE=100000
export CLICOLOR=1 # Enable colorized ls on FreeBSD

shopt -s checkwinsize

PATH=$PATH:~/bin:~/.local/bin

export EDITOR=emacs
export PAGER=less

# Turn off system mail checking
shopt -u mailwarn
unset MAILCHECK

if [ -e ~/.bashrc_aliases ]; then
  . ~/.bashrc_aliases
fi

if [ -e ~/.bashrc_functions ]; then
  . ~/.bashrc_functions
fi

if ! pgrep ssh-agent > /dev/null; then
  ssh-agent > ~/.ssh-agent-thing
fi
if [[ "$SSH_AGENT_PID" == "" ]]; then
  eval $(<~/.ssh-agent-thing)
fi
ssh-add -l >/dev/null || alias ssh='ssh-add -l >/dev/null || ssh-add && unalias ssh; ssh'

# For FreeBSD
[[ -f /usr/local/share/bash-completion/bash_completion.sh ]] && \
  source /usr/local/share/bash-completion/bash_completion.sh

PS1='[\u@\h \W]$(git_prompt)\$ ' # the git_prompt function is in the .bashrc_functions file

# Activate homeshick if available

if [[ -e "$HOME/.homesick/repos/homeshick/homeshick.sh" ]]; then
  source "$HOME/.homesick/repos/homeshick/homeshick.sh"
  source "$HOME/.homesick/repos/homeshick/completions/homeshick-completion.bash"
  homeshick --batch --quiet refresh
fi

if [[ -s "$HOME/.rvm/scripts/rvm" ]]; then
  source "$HOME/.rvm/scripts/rvm"
  export PATH="$PATH:$HOME/.rvm/bin"
fi

# Import misc config files

if [[ -e "$HOME/.bash.d" ]]; then
  for f in "$HOME"/.bash.d/*; do
    . "$f"
  done
fi

echo -ne $cyan$(hostname)$NC" - "
echo -ne $red; uname -smr
echo -ne $blue; date
echo -ne $NC
if [ -x /usr/games/fortune ]; then
  /usr/games/fortune -s     # makes our day a bit more fun
elif [ -x /usr/bin/fortune ]; then
  /usr/bin/fortune -s
fi

echo -ne $NC
