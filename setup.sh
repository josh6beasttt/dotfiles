#!/bin/bash -e

ln -sf ~/Dotfiles/.dotfilesrc ~/.dotfilesrc
pip install --upgrade dotfiles
dotfiles --sync

for dir in ~/Dotfiles/AppSupport/*; do
    ln -sf $dir ~/Library/Application\ Support/
done
