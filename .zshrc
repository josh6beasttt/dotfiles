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

# Antigen syntax highlighting and theming
source ~/antigen/antigen.zsh
antigen-use oh-my-zsh
antigen-theme bira
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
alias teensy="dfu-programmer atmega32u4"
alias i3-restart="i3-msg -t command restart"

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
# Edit an rc file and then source it
function rc { $EDITOR $1 && source $1 }
# Change Java version to the first arg typed. Ex: 1.7, 1.8...
function changeJavaVersion {
    gsed -i "s/1\.[5-9]/$1/g" ~/.zshrc_override
}

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
# Git
######################################################################
alias gs="git status"
alias glg="git lg"
alias gdm="git diff master"

alias gerrit_push="git push origin HEAD:refs/for/master"
alias gerrit_draft="git push origin HEAD:refs/drafts/master"

function grev {
    git revert --no-commit $1..HEAD && git commit
}

function git_new_branch {
    gcm && gl && gco -b $1
}

############################################################
# Android
############################################################
export ANDROID_HOME="/usr/local/opt/android-sdk"
export PATH="$ANDROID_HOME/platform-tools:$PATH"
export PATH="$ANDROID_HOME/tools:$PATH"
export PATH="$ANDROID_HOME/build-tools/21.0.2:$PATH" 

alias adbs=adb_select

# Captures a screenshot of the selected Android device. Always
# save with the .png extension.
# Usage example: "adb_screencap ~/Pictures/myDeviceScreenshot.png"
function adb_screencap {
    if [ -z "$*" ]; then
        echo "No file output specified"
        return 1
    fi 
    ensureAndroidSerialValid
    adb shell screencap -p | perl -pe 's/\x0D\x0A/\x0A/g' > $1
}
# Send text to the selected Android device. "adb_type" alone will
# provide an interactive text editor. "adb_type foo bar baz" will
# send "foo bar baz" to the device. 
function adb_type {
    ensureAndroidSerialValid
    if [ -z "$1" ]; then
        echo "Enter what you would like to send to this device:"
        read TEXT
    else
        TEXT="$@"
    fi
    adb shell input text $(echo $TEXT | sed s/" "/"%s"/g)
}
# Simple, easy to read list of ADB devices with model #s
function adbd {
    # Splits only at newlines when using "for", not at any whitespace.
    OLD_IFS=${IFS}
    IFS=$'\n'

    TABLE_FORMAT=$(echo "%-20s %s $(tput sgr0)")
    for d in $(adb devices -l | grep "   "); do
        ID=$(echo $d | cut -d' ' -f1)
        MODEL=$(echo $d | awk -v FS="(model:)" '{print $2}' | cut -d' ' -f1)
        printf $TABLE_FORMAT "$ID" "$(tput setaf 2; echo $MODEL)"
        echo
    done
    IFS=${OLD_IFS}
}
# Provides the list from above, and allows you to select one as the active
# device for other commands, avoiding the need for the -s flag.
function adb_select {
    EXIT_CHOICE="Abort"
    PS3="Type the number next to the device you want to select: "
    OLD_IFS=${IFS}
    IFS=$'\n'
    select CHOICE in $(adbd); do
        if [ ! -z "$CHOICE" ]; then
            ID=$(echo $CHOICE | awk '{print $1}')
            MODEL=$(echo $CHOICE | awk '{print $2}')
            export ANDROID_SERIAL="$ID"
            echo "ADB commands will run against $ID ($MODEL$(tput sgr0))"
            break
        else 
            echo "Invalid choice"
        fi
    done
    IFS=${OLD_IFS}
    return 0
}
# Provides a prompt before bringing up adb_select
function adbPromptSelectDevice {
    echo "Press [ENTER] to continue"
    read -n 1
    adb_select
}
# Forces reselection if $ANDROID_SERIAL is not valid
function ensureAndroidSerialValid {
    NUM_DEVICES=$(adb devices | grep "$ANDROID_SERIAL" | wc -l | awk '{print $1}')
    if [ -z "$ANDROID_SERIAL" ]; then
        echo '$ANDROID_SERIAL is not set, you need to select an ADB device'
    elif [ "$NUM_DEVICES" -ne "1" ]; then
        echo '$ANDROID_SERIAL no longer points to a valid target, please re-select a device.'
    else
        return 0
    fi
    adbPromptSelectDevice
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
