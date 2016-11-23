export DOTFILES=$HOME/dotfiles
export ZSH=$HOME/.oh-my-zsh
export RANGER_LOAD_DEFAULT_RC=FALSE

export TERM=xterm-256color
export EDITOR=vim

export KEYTIMEOUT=1

export JAVA_HOME=/Library/Java/Home
export ANDROID_HOME=$HOME/Library/Android/sdk
export ANDROID_SDK=$ANDROID_HOME
export ANDROID_SDK_HOME=$ANDROID_HOME
export NDK=$ANDROID_HOME/ndk-bundle
export NDK_ROOT=$NDK
export ANDROID_NDK_HOME=$NDK

###############################################################################
# PATH
###############################################################################
export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/texbin"
export PATH="$ANDROID_HOME/platform-tools:$PATH"
export PATH="$ANDROID_HOME/tools:$PATH"

######################################################################
# Aliases
######################################################################
alias rm=trash
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
alias v="vim"
alias teensy="dfu-programmer atmega32u4"
alias i3-restart="i3-msg -t command restart"
eval $(thefuck --alias)

######################################################################
# Functions
######################################################################
function loop {
    while true; do; $@; sleep 1; done;
}
function cl { cd $1; ls; }
function lsproc {
    args=("$@")
    for e in "${args[@]}"; do
        regex="[${e:0:1}]${e:1}"
        ps aux | grep --color ${regex}
    done
}
# Converts all FLACs in pwd to MP3
function flac2mp3 { parallel -j 4 'a={}; ffmpeg -i "$a" -qscale:a 0 "${a[@]/%flac/mp3}"' ::: *.flac; }
# Convert to webm
function toWebM { ffmpeg -i $1 -c:v libvpx -qmin 0 -qmax 50 -crf 5 -b:v 1M -c:a libvorbis $1.webm }
# Count lines in a file
function countlines { wc -l $1 | tr -d ' ' }
# Edit an rc file and then source it
function rc { $EDITOR $1 && source $1 }
# `g` runs `git status`; `g [anything else]` runs `git [anything else]`
unalias g
function g {
    if [ $# -eq 0 ]; then
        git status
    else
        git $@
    fi
}

######################################################################
# Git
######################################################################
alias gs="git status"
alias glg="git lg"
alias gdm="git diff master"
alias gap="git add -p ."
alias gca="git commit --amend"
alias gb="git branch -vv"

alias gerrit_push="git push origin HEAD:refs/for/master"
alias gerrit_draft="git push origin HEAD:refs/drafts/master"

function grev {
    git revert --no-commit $1..HEAD && git commit
}

function git_new_branch {
    gcm && gl && gco -b $1
}

function git_prune_branches {
    git checkout master && git branch -vv | grep ': gone]' | awk '{print $1}' | xargs git branch -d
}

function git_submodule_init {
	git config -f .gitmodules --get-regexp '^submodule\..*\.path$' |
	while read path_key path
	do
		url_key=$(echo $path_key | sed 's/\.path/.url/')
		url=$(git config -f .gitmodules --get "$url_key")
		git submodule add $url $path
	done
}

############################################################
# Android
############################################################
alias adbs=adb_select

# Captures a screenshot of the selected Android device. Always
# save with the .png extension.

# Captures a screenshot of the selected Android device. Always
# save with the .png extension.

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

function telecine_pull {
    ensureAndroidSerialValid
    FILE=$(adb shell "ls -d /sdcard/Movies/Telecine/*" | tail -1 | sed $'s/\r//')
    adb pull $FILE ~/Downloads/
}

######################################################################
# Gradle
######################################################################
export GRADLE_HOME=/usr/local/opt/gradle/libexec
alias gdl="./gradlew"
alias gdlcb="./gradlew clean build"
alias gdlb="./gradlew build"
alias gdlc="./gradlew clean"

######################################################################
# Rust
######################################################################
source $HOME/.cargo/env
export RUST_SRC_PATH=$HOME/code/languages/rust/src
# Because Rust thinks we'll have OpenSSL installed
export OPENSSL_INCLUDE_DIR=/usr/local/opt/openssl/include

######################################################################
# Others
######################################################################
for f in $HOME/.shellenvs/*; do
    source $f
done
