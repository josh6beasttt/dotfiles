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

# Always use vimpager instead of less/more
export PAGER=/usr/local/bin/vimpager
alias less=$PAGER
alias zless=$PAGER
alias more=$PAGER

######################################################################
# Various HOMEs
######################################################################
export BREW_HOME=/usr/local/Cellar
export APACHE_HOME=$BREW_HOME/apr/1.5.1
export MAMP_HOME=/Applications/MAMP
export SPARK_HOME=$BREW_HOME/apache-spark/1.1.0/libexec
export ANDROID_HOME=/usr/local/opt/android-sdk
if [ `uname` = "Darwin" ]; then
    export JAVA_HOME=$(/usr/libexec/java_home)
fi

######################################################################
# Perka
######################################################################
source ~/.perkarc

######################################################################
# Aliases
######################################################################
alias git=hub
alias bfg="java -jar bfg.jar"
if [ `uname` = "Darwin" ]; then
    alias ls="ls -G"
else
    alias ls="ls --color"
fi
alias grep="grep --color"
alias egrep="egrep --color"
alias mv="mv -i"
alias ack="ag"
alias ggpo="nohup wine ~/Dropbox/Programs/Games/GGPO/ggpo.exe &"
alias ggpofba="nohup wine ~/Dropbox/Programs/Games/GGPO/ggpofba.exe &"

######################################################################
# Functions
######################################################################
function cdls { cd $1; ls; }
function mkls { mkdir -p $1; ls $1; }
function pid { ps aux|grep $1; }
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

######################################################################
# Other PATHs
######################################################################
export PYTHONPATH=$(brew --prefix)/lib/python2.7/site-packages

######################################################################
# Local ~/.zshrc_override
######################################################################
# Sometimes there are computer-specific commands that you want in your rc file that should not be present on every computer
# Put these commands into ~/.zshrc_override and they will be run on this local machine, but not synced into the git repo
if [ -f $HOME/.zshrc_override ]; then
    source $HOME/.zshrc_override
fi
