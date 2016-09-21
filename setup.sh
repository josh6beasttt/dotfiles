#!/bin/bash -e

ln -sf ~/Dotfiles/.dotfilesrc ~/.dotfilesrc
sudo easy_install pip
sudo pip install --upgrade dotfiles
dotfiles --sync

for dir in ~/Dotfiles/AppSupport/*; do
    echo "Symlinking $dir"
    ln -sf $dir ~/Library/Application\ Support/
done
