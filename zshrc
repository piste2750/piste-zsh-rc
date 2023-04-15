##
#  Zsh history configuration
#
export HISTFILE=${HOME}/.zsh_history
export HISTSIZE=1000
export SAVEHIST=100000
setopt hist_ignore_all_dups
setopt hist_reduce_blanks
setopt hist_no_store
setopt hist_expand
setopt extended_history
setopt share_history
setopt inc_append_history

##
#  Exports
#
export LANG=en_US.UTF-8
export ICU_PATH="/usr/local/opt/icu4c/bin"
export LIBXML2_PATH="/usr/local/opt/libxml2/bin"
export PKG_CONFIG_PATH="/usr/local/opt/icu4c/lib/pkgconfig:/usr/local/opt/libxml2/lib/pkgconfig"
export NODE_PATH='~/.nodebrew/current/bin'
export TEXPATH='/Library/TeX/texbin'
export PATH="${TEXPATH}:/usr/local/sbin:${PATH}:${ICU_PATH}:${LIBXML2_PATH}:${NODE_PATH}"
#export XMODIFIERS="@im=uim"
#export GTK_IM_MODULE=uim

##
#  Aliases
#
alias ls='gls --color=auto'
alias refreshdns='sudo killall mDNSResponder'
alias emacs-nw='/usr/local/bin/emacs -nw'
alias gitpull='git pull --rebase'

##
#  Functions
#
function emacs()
{
	if [ ! -e ${1} ]; then
		touch ${1}
	fi
	LANG=en_US open -a Emacs -n ${1}
}

function tunnel()
{
	if [ "x${1}" = "x" ]; then
		echo "usage tunnel host"
	else
		ssh -R 10022:localhost:22 ${1} ssh -N -D 10080 -p 10022 piste@localhost
	fi
}

function tunnel_g()
{
	if [ "x${1}" = "x" ]; then
		echo "usage tunnel host"
	else
		ssh -R 10022:localhost:22 ${1} ssh -N -D 10080 -p 10022 -g piste@localhost
	fi
}

function dark {
    unset DARK
    export DARK="YES"
    eval `gdircolors ~/dircolors-clearly/dircolors-clearly.256dark`
    launchctl setenv DARK YES
    zstyle ':vcs_info:git:*' check-for-changes true    # Use %c, %u on 'formats'
    zstyle ':vcs_info:git:*' stagedstr "%F{yellow}!"   # Have uncommited files
    zstyle ':vcs_info:git:*' unstagedstr "%F{red}+"    # Have non-staging files
    zstyle ':vcs_info:*' formats "%F{green}%c%u[%b]%f" # Normal string format
    zstyle ':vcs_info:*' actionformats '[%b|%a]'       # Need some actions
}

function light {
    unset DARK
    export DARK="NO"
    eval `gdircolors ~/dircolors-clearly/dircolors-clearly.256light`
    launchctl setenv DARK NO
    zstyle ':vcs_info:git:*' check-for-changes true     # Use %c, %u on 'formats'
    zstyle ':vcs_info:git:*' stagedstr "%F{yellow}!"    # Have uncommited files
    zstyle ':vcs_info:git:*' unstagedstr "%F{magenta}+" # Have non-staging files
    zstyle ':vcs_info:*' formats "%F{blue}%c%u[%b]%f"   # Normal string format
    zstyle ':vcs_info:*' actionformats '[%b|%a]'        # Need some actions
}

# Set backgrounnd color environment
if [ x"$DARK" = 'x' ]; then
    export DARK="NO"
fi

export RATINA="NO"

##
#  Setting for VCS info
#
autoload -Uz vcs_info
precmd_vcs_info() { vcs_info }
precmd_functions+=( precmd_vcs_info )
setopt prompt_subst

PROMPT='%m:%c %n'
PROMPT=$PROMPT'${vcs_info_msg_0_}%% '

##
#  Final color configuration
#
if [ x"$DARK" = 'xYES' ]; then
    dark
else
    light
fi

##
#  zaw
#
source ~/github/zaw/zaw.zsh
zstyle ':filter-select' case-insensitive yes
zstyle ':filter-select' max-lines 10

# You can configure the default action for each source
#zstyle ':zaw:history' default zaw-callback-replace-buffer
#zstyle ':zaw:history' alt zaw-callback-execute

bindkey '^R' zaw-history
bindkey '^B' history-incremental-search-backward
bindkey '^Xd' zaw-cdr
bindkey '^Xf' zaw-fasd-directories
bindkey '^Xh' zaw-ssh-hosts
bindkey '^Xc' zaw-command-output

# Exit from filter-select in Ctrl-e or right-arrow-key
bindkey -M filterselect '^E' accept-search
bindkey -M filterselect '\e[C' accept-search
bindkey -M filterselect '\eOC' accept-search
