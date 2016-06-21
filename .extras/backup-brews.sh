#!/bin/bash

brew leaves > brew-leaves.txt
brew cask list | sed 's/\s+/\n/g' | sed 's/ (!)//g' > brew-casks.txt
