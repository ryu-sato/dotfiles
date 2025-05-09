# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=100000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi


# portable binaryes
export PATH="$HOME/.bin:$PATH"

# Settings for Docker
# [Docker for Windows]
#   Use docker for windows in WSL bash
#   cf. https://qiita.com/yoichiwo7/items/0b2aaa3a8c26ce8e87fe
KERNEL=$(uname -r | sed -e 's/^[0-9.\-]\+//')
if [ "$KERNEL" == "Microsoft" ]; then
  export DOCKER_HOST='tcp://0.0.0.0:2375'
fi

# Override SSH Socket
# ref. https://qiita.com/sonots/items/2d7950a68da0a02ba7e4
agent="$HOME/.ssh/agent"
if [ -S "$SSH_AUTH_SOCK" ]; then
    case $SSH_AUTH_SOCK in
    /tmp/*/agent.[0-9]*)
        ln -snf "$SSH_AUTH_SOCK" $agent && export SSH_AUTH_SOCK=$agent ;;
    /run/user/*)
        # VSCode からの接続の場合は何もしない
        ;;
    esac
elif [ -S $agent ]; then
    export SSH_AUTH_SOCK=$agent
else
    echo "no ssh-agent"
fi
# wsl2-ssh-pagent
# https://github.com/BlackReloaded/wsl2-ssh-pageant
if [ -f "$HOME/.ssh/wsl2-ssh-pageant.exe" ]; then
  export SSH_AUTH_SOCK="$HOME/.ssh/agent.sock"
  if ! ss -a | grep -q "$SSH_AUTH_SOCK"; then
    rm -f "$SSH_AUTH_SOCK"
    wsl2_ssh_pageant_bin="$HOME/.ssh/wsl2-ssh-pageant.exe"
    if test -x "$wsl2_ssh_pageant_bin"; then
      if test -x "socat"; then
        (setsid nohup socat UNIX-LISTEN:"$SSH_AUTH_SOCK,fork" EXEC:"$wsl2_ssh_pageant_bin" >/dev/null 2>&1 &)
      else
        echo >&2 "WARNING: socat is not executable."
      fi
    else
      echo >&2 "WARNING: $wsl2_ssh_pageant_bin is not executable."
    fi
    unset wsl2_ssh_pageant_bin
  fi
else
  echo "cannot found wsl2-ssh-pageant"
fi

# Kubernetes
if [ -n "$(which kubectl)" -a $? = 0 ]; then
  alias k='kubectl'
  complete -F __start_kubectl k
  source <(kubectl completion bash)
fi

# kubectx and kubens(https://github.com/ahmetb/kubectx)
if [ -d ~/.kubectx ]; then
  export PATH=~/.kubectx:$PATH
fi

# kubeps(https://github.com/jonmosco/kube-ps1)
if [ -d ~/.kube-ps1 ]; then
  source ~/.kube-ps1/kube-ps1.sh
  PS1='\[\e]0;\h: \w\a\]${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\] $(kube_ps1)\$ '
  kubeoff
fi

# pyenv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi

# asdf
if [ -d ~/.asdf ]; then
  . $HOME/.asdf/asdf.sh
  . $HOME/.asdf/completions/asdf.bash
fi

# golang
if [ "$(which go 2>&1 > /dev/null)" -a $? = 0 ]; then
  export GOPATH="$HOME/.gopath"
  export PATH="$HOME/.gopath/bin:$PATH"
fi

# Google Cloud SDK and gcloud and enables shell command completion for gcloud
if [ -f "$HOME/work/google-cloud-sdk/path.bash.inc" ]; then
  . "$HOME/work/google-cloud-sdk/path.bash.inc";
fi
if [ -f "$HOME/work/google-cloud-sdk/completion.bash.inc" ]; then
  . "$HOME/work/google-cloud-sdk/completion.bash.inc";
fi

# add Pulumi to the PATH
if [ -f "$HOME/.pulumi/bin/pulumi" ]; then
  export PATH=$PATH:$HOME/.pulumi/bin
fi

# override
if [ -f "$HOME/.bashrc.local" ]; then
  . $HOME/.bashrc.local
fi

# krew
if [ -d "$HOME/.krew" ]; then
  export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
fi


# The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/ryu/google-cloud-sdk/path.bash.inc' ]; then . '/home/ryu/google-cloud-sdk/path.bash.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/home/ryu/google-cloud-sdk/completion.bash.inc' ]; then . '/home/ryu/google-cloud-sdk/completion.bash.inc'; fi
