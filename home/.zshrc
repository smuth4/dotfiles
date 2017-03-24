# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH
PATH=/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/sbin:/usr/local/bin
PATH=$PATH:~/bin:~/.local/bin
export PATH

# Define some colors first:
red='\033[0;31m'
#RED='\033[1;31m'
blue='\033[0;34m'
#BLUE='\033[1;34m'
cyan='\033[0;36m'
#CYAN='\033[1;36m'
NC='\033[0m'              # No Color

# Path to your oh-my-zsh installation.
export ZSH=~/.oh-my-zsh

if [[ -e "$HOME/.zsh.d" ]]; then
  for f in "$HOME"/.zsh.d/*; do
    . "$f"
  done
fi

if [[ -e "$HOME/.zsh.completions.d" ]]; then
  fpath=("$HOME/.zsh.completions.d" "${fpath[@]}")
fi

# Stealing straight from bash
if [ -e ~/.bashrc_aliases ]; then
  . ~/.bashrc_aliases
fi
if [ -e ~/.bashrc_functions ]; then
  . ~/.bashrc_functions
fi
if [[ -e "$HOME/.bash.d" ]]; then
  for f in "$HOME"/.bash.d/*; do
    . "$f"
  done
fi

# Turn the useless Ctrl-s/Ctrl-q commands off
stty stop undef
stty start undef

if ! pgrep -u "$UID" ssh-agent > /dev/null; then
  ssh-agent > ~/.ssh-agent-thing
fi
if [[ "$SSH_AGENT_PID" == "" && -e ~/.ssh-agent-thing ]]; then
  eval $(<~/.ssh-agent-thing)
fi
ssh-add -l >/dev/null || alias ssh='ssh-add -l >/dev/null || ssh-add && unalias ssh; ssh'

if [[ -e /usr/share/terminfo/x/xterm-256color || \
        -e /lib/terminfo/x/xterm-256color || \
        -e /opt/local/share/terminfo/78/xterm-256color ]]; then # OS X
  export TERM='xterm-256color'
else
  export TERM='xterm-color'
fi


# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="daveverwer"

export CLICOLOR=1 # Enable colorized ls on FreeBSD
export EDITOR=emacs
export PAGER=less

# Turn off system mail checking
unset MAILCHECK

if [[ -e "$HOME/.homesick/repos/homeshick/homeshick.sh" ]]; then
  source "$HOME/.homesick/repos/homeshick/homeshick.sh"
  fpath=("$HOME/.homesick/repos/homeshick/completions" "${fpath[@]}")
  homeshick --quiet --batch --force refresh
fi

if [[ -e "$HOME/.zsh.completions.d" ]]; then
  fpath=("$HOME/.zsh.completions.d" "${fpath[@]}")
fi

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=()

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh
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
