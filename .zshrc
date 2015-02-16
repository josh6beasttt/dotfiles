# Truly the most important part of this entire rc file
fortune | cowsay

######################################################################
# Boilerplate
######################################################################
export DOTFILES=$HOME/dotfiles

export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/texbin"

export ZSH=$HOME/.oh-my-zsh

ZSH_THEME="bira"

HIST_STAMPS="yyyy-mm-dd"

# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
plugins=(brew dirhistory git git-extras gradle jsontools mvn osx python)

source $ZSH/oh-my-zsh.sh

# Antigen syntax highlighting
source ~/antigen/antigen.zsh
antigen bundle zsh-users/zsh-syntax-highlighting
antigen apply

# Make sure our terminal actually tells programs that it supports 256-color
export TERM=xterm-256color

export EDITOR=vim

######################################################################
# Various HOMEs
######################################################################
export BREW_HOME=/usr/local/Cellar
export APACHE_HOME=$BREW_HOME/apr/1.5.1
export MAMP_HOME=/Applications/MAMP
export SPARK_HOME=$BREW_HOME/apache-spark/1.2.0/libexec
export ANDROID_SDK=$BREW_HOME/android-sdk/24.0.1

######################################################################
# Perka
######################################################################
source ~/.perkarc

######################################################################
# Aliases
######################################################################
alias git=hub
if [ `uname` = "Darwin" ]; then
    alias ls="ls -G"
else
    alias ls="ls --color"
fi
alias grep="grep --color"
alias egrep="egrep --color"
alias mv="mv -i"
alias ack="ag"

######################################################################
# Functions
######################################################################
function cdls { cd $1; ls; }
function mkls { mkdir -p $1; ls $1; }
function lsproc {
    args=("$@")
    for e in "${args[@]}"
    do
        regex="[${e:0:1}]${e:1}"
        ps aux | grep --color ${regex}
    done
}
# Converts all FLACs in pwd to MP3
function flac2mp3 { parallel -j 4 'a={}; ffmpeg -i "$a" -qscale:a 0 "${a[@]/%flac/mp3}"' ::: *.flac; }
# Count lines in a file
function countlines { wc -l $1 | tr -d ' ' }

######################################################################
# Options
######################################################################
export HOMEBREW_CASK_OPTS="--appdir=/Applications" # Always install Casks into /Applications

######################################################################
# Binaries to add to PATH
######################################################################
export PATH="$PATH:/opt/st2" # Add Sublime to PATH
export PATH="$PATH:$HOME/dotfiles/bin" # Add custom binaries from my Git repo
export PATH="$PATH:/Library/Ruby/Gems/2.0.0/gems" # Add Ruby Gems
export PATH="$PATH:/usr/local/CrossPack-AVR/bin" #Add AVR binaries

######################################################################
# Other PATHs
######################################################################
export PYTHONPATH=$(brew --prefix)/lib/python2.7/site-packages

######################################################################
# Git
######################################################################
alias gs="git status"

function grev {
    git revert --no-commit $1..HEAD && git commit
}

############################################################
# Android
############################################################
export ANDROID_HOME="/usr/local/opt/android-sdk"
export PATH="$ANDROID_HOME/platform-tools:$PATH"
export PATH="$ANDROID_HOME/tools:$PATH"
export PATH="$ANDROID_HOME/build-tools/21.0.2:$PATH" 

alias adbd="adb devices"
alias clover="adb connect 192.168.2.104:555"

function android_screencap {
    if [ -z "$*" ]; then
        echo "No file output specified"
        return 1
    fi 
    adb shell screencap -p | perl -pe 's/\x0D\x0A/\x0A/g' > $1
}
function android_type {
    adb shell input text "$@"
}

######################################################################
# Golang
######################################################################
export GOPATH=$HOME/Github/go-workbench
export PATH=$PATH:/usr/local/opt/go/libexec/bin


######################################################################
# Local ~/.zshrc_override
######################################################################
# Sometimes there are computer-specific commands that you want in your rc file that should not be present on every computer
# Put these commands into ~/.zshrc_override and they will be run on this local machine, but not synced into the git repo
if [ -f $HOME/.zshrc_override ]; then
    source $HOME/.zshrc_override
fi
