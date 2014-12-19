# Install homebrew
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# Tap brew taps
brew tap caskroom/cask
brew tap caskroom/versions
brew tap homebrew/science
brew tap homebrew/versions
brew tap jlhonora/lsusb
brew tap mopidy/mopidy

# Install brew packages
brew install ack android-sdk apache-spark bash brew-cask cassandra cloc cmus coreutils cowsay cuetools cvs daemonize dotwrp fortune gawk gcc git gnu-sed go graphicsmagick heroku-toolbelt hub id3lib imagemagick jetty jq libev libfreenect lsusb maven mercurial mobile-shell mopidy mpd mutt mysql ncmpcpp node nvm p7zip pandoc parallel python s3cmd scala solr the_silver_searcher v8 watch wget wine winetricks zenity zsh

# Install brew-cask packages
brew cask install --appdir="/Applications" adium
brew cask install --appdir="/Applications" alfred
brew cask install --appdir="/Applications" android-studio
brew cask install --appdir="/Applications" asepsis
brew cask install --appdir="/Applications" atom
brew cask install --appdir="/Applications" basictex
brew cask install --appdir="/Applications" bettertouchtool
brew cask install --appdir="/Applications" betterzipql
brew cask install --appdir="/Applications" caffeine
brew cask install --appdir="/Applications" clipmenu
brew cask install --appdir="/Applications" deluge
brew cask install --appdir="/Applications" disk-inventory-x
brew cask install --appdir="/Applications" dropbox
brew cask install --appdir="/Applications" filezilla
brew cask install --appdir="/Applications" flux
brew cask install --appdir="/Applications" genymotion
brew cask install --appdir="/Applications" gimp
brew cask install --appdir="/Applications" google-chrome
brew cask install --appdir="/Applications" google-hangouts
brew cask install --appdir="/Applications" hyperswitch
brew cask install --appdir="/Applications" intellij-idea
brew cask install --appdir="/Applications" iterm2
brew cask install --appdir="/Applications" java
brew cask install --appdir="/Applications" java6
brew cask install --appdir="/Applications" java7
brew cask install --appdir="/Applications" karabiner
brew cask install --appdir="/Applications" keka
brew cask install --appdir="/Applications" mamp
brew cask install --appdir="/Applications" mpv
brew cask install --appdir="/Applications" phpstorm
brew cask install --appdir="/Applications" qlcolorcode
brew cask install --appdir="/Applications" qlmarkdown
brew cask install --appdir="/Applications" qlprettypatch
brew cask install --appdir="/Applications" qlstephen
brew cask install --appdir="/Applications" quicklook-csv
brew cask install --appdir="/Applications" quicklook-json
brew cask install --appdir="/Applications" seil
brew cask install --appdir="/Applications" spectacle
brew cask install --appdir="/Applications" steam
brew cask install --appdir="/Applications" sublime-text3
brew cask install --appdir="/Applications" suspicious-package
brew cask install --appdir="/Applications" virtualbox
brew cask install --appdir="/Applications" webp-quicklook
brew cask install --appdir="/Applications" xquartz

# Enable press-and-hold repeating characters
defaults write -g ApplePressAndHoldEnabled -bool false
# Seriously, no hidden files or extensions by default? What is this, Windows?
defaults write com.apple.finder AppleShowAllFiles TRUE;killall Finder
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
# Speed up animations
defaults write com.apple.dock expose-animation-duration -float 0.15;killall Dock

# Add zsh to /etc/shells
echo /usr/local/bin/zsh >> /etc/shells
# Change to zsh
chsh -s /usr/local/bin/zsh
# Install oh-my-zsh
curl -L http://install.ohmyz.sh | sh
# Install antigen and syntax highlighter
curl -L https://raw.githubusercontent.com/zsh-users/antigen/master/antigen.zsh > antigen.zsh
source antigen.zsh
antigen bundle zsh-users/zsh-syntax-highlighting

# Install Vundle 
git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim

# Notes for the user
echo "Remember to run the \"android\" tool at some point to install your Android SDK"
