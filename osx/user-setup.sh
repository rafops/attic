#!/bin/bash

defaults write com.apple.finder ShowHardDrivesOnDesktop -bool false
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool false
# defaults write com.apple.finder AppleShowAllFiles YES
killall -HUP Finder

# Install Oh My Zsh

sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# Install rbenv

git clone https://github.com/rbenv/rbenv.git ~/.rbenv
cd ~/.rbenv && src/configure && make -C src
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"

echo '' >> ~/.zshrc
echo '# rbenv' >> ~/.zshrc
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.zshrc
echo 'eval "$(rbenv init -)"' >> ~/.zshrc

# Install FiraCode font

echo "curl -L -O https://github.com/tonsky/FiraCode/releases/download/1.204/FiraCode_1.204.zip"
echo "https://github.com/tonsky/FiraCode/wiki/Atom-instructions"

# Install aws cli

pip3 install --user --upgrade awscli

echo '' >> ~/.zshrc
echo '# Python 3 binaries (AWS CLI)' >> ~/.zshrc
echo 'export PATH="$PATH:$HOME/Library/Python/3.6/bin"' >> ~/.zshrc

# https://discussions.apple.com/thread/5543840?tstart=0
