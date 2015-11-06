# This will be faster if we install our ethernet drivers first
echo "This will be faster if you download your ethernet drivers first"
open http://www.asix.com.tw/download.php?sub=driverdetail&PItemID=131
read -p "Press [Enter] if you have already installed those drivers and restarted your computer"

# This command is the worst because it requires GUI interactions
clear
echo "Time to install Xcode dev tools, click Install on the popup. NOT Get XCode!!!"
xcode-select --install

# Install homebrew
clear
echo "Installing Homebrew"
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# Tap brew taps
clear
echo "Tapping extra Homebrew Casks"
brew tap caskroom/cask
brew tap caskroom/versions
brew tap homebrew/science
brew tap homebrew/versions
brew tap jlhonora/lsusb
brew tap mopidy/mopidy

# Pre-installation reqs.
clear
echo "Installing some dependencies before we install all the big packages, this might hang for a while, but it's okay!"
brew install Caskroom/cask/xquartz
brew install brew-cask
brew cask install java

# Install brew packages
clear
echo "Installing command-line tools via brew"
brew install ack \
	apache-spark \
	bash \
	brew-cask \
	cassandra \
	cloc \
	cmus \
	coreutils \
	cowsay \
	cuetools \
	cvs \
	daemonize \
	dotwrp \
	fortune \
	gawk \
	gcc \
	git \
	gnu-sed \
	go \
	graphicsmagick \
	heroku-toolbelt \
	hub \
	id3lib \
	imagemagick \
	jetty \
	jq \
	libev \
	libfreenect \
	lsusb \
	maven \
	mercurial \
	mobile-shell \
	mopidy \
	mpd \
	mutt \
	ncmpcpp \
	nvm \
	p7zip \
	pandoc \
	parallel \
	pidcat \
	python \
	s3cmd \
	scala \
	solr \
	thefuck \
	the_silver_searcher \
	tree \
	v8 \
	watch \
	wget \
	wine \
	winetricks \
	zenity \
	zsh

# Post-command-line-setup stuff
# mpd starts at boot
mkdir -p ~/Library/LaunchAgents
ln -sfv /usr/local/opt/mpd/*.plist ~/Library/LaunchAgents
# Why does nvm want me to make this directory? I don't even know. Thanks JS devs.
mkdir -p ~/.nvm

# Install brew-cask packages
clear
echo "Installing GUI apps via brew-cask"
brew cask install adium \
	alfred \
	android-studio \
	basictex \
	bettertouchtool \
	betterzipql \
	clipmenu \
	deluge \
	disk-inventory-x \
	dropbox \
	filezilla \
	flux \
	genymotion \
	gimp \
	google-chrome \
	intellij-idea \
	iterm2-nightly \
	karabiner \
	keepingyouawake \
	keka \
	mpv \
	postgres \
	qlcolorcode \
	qlmarkdown \
	qlprettypatch \
	qlstephen \
	quicklook-csv \
	quicklook-json \
	scroll-reverser \
	seil \
    slack \
	spark \
	spectacle \
	spotify \
	steam \
	sublime-text3 \
	teamviewer \
	virtualbox \
	webpquicklook \
	xquartz

clear
echo "Fixing the awful things that OS X thinks are okay to set as defaults"
# Enable press-and-hold repeating characters
defaults write -g ApplePressAndHoldEnabled -bool false
# Seriously, no hidden files or extensions by default? What is this, Windows?
defaults write com.apple.finder AppleShowAllFiles TRUE;killall Finder
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
# Speed up animations
defaults write com.apple.dock expose-animation-duration -float 0.15;killall Dock
# Proper anti-aliasing
defaults -currentHost write -globalDomain AppleFontSmoothing -int 3

clear
echo "Installing the best shell"
# Add zsh to /etc/shells
sudo sh -c 'echo /usr/local/bin/zsh >> /etc/shells'
# Change to zsh
chsh -s /usr/local/bin/zsh
# Install oh-my-zsh
curl -L http://install.ohmyz.sh | sh
# Install antigen
git clone https://github.com/zsh-users/antigen.git ~/.antigen-repo

# Install Android ADB + fastboot. Because android > xcode, there is a no-ui option, too!
android update sdk --no-ui --filter 'platform-tools'

# Restore muh freedoms
python scripts-osx/fix-macosx.py
