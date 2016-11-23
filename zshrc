ZSH_THEME="bira"
HIST_STAMPS="yyyy-mm-dd"

# Antigen syntax highlighting and theming
source ~/.antigen-repo/antigen.zsh
antigen-use oh-my-zsh
antigen-theme bira

# Plugins!
ANTIGEN_PLUGINS=(
    adb
    brew
    dirhistory
    gitfast
    git-extras
    gradle 
    jsontools 
    mvn 
    python 
    vi-mode
    zsh-users/zsh-syntax-highlighting
)
for plugin in $ANTIGEN_PLUGINS; do
    antigen bundle $plugin
done

antigen apply

# This clobbered a bunch of aliases I had, so we need to reset them
source ~/.zshenv

# zsh vi mode
bindkey -v

#bindkey '^P' up-history
#bindkey '^N' down-history
#bindkey '^?' backward-delete-char
#bindkey '^h' backward-delete-char
#bindkey '^w' backward-kill-word
#bindkey '^r' history-incremental-search-backward

precmd() { RPROMPT="" }
function zle-line-init zle-keymap-select {
   VIM_PROMPT="%{$fg_bold[yellow]%} [% NORMAL]%  %{$reset_color%}"
   RPS1="${${KEYMAP/vicmd/$VIM_PROMPT}/(main|viins)/} $EPS1"
   zle reset-prompt
}

zle -N zle-line-init
zle -N zle-keymap-select

# added by travis gem
[ -f $HOME/.travis/travis.sh ] && source $HOME/.travis/travis.sh

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
