#!/bin/bash

hostname=desktop
admin_user=admin

# Set computer name and hostname

sudo scutil --set ComputerName  $hostname
sudo scutil --set LocalHostName $hostname

# Do not keep file vault key on standby

sudo pmset -a destroyfvkeyonstandby 1

# Do not hibernate

sudo pmset -a hibernatemode 25
sudo pmset -a powernap 0
sudo pmset -a standby 0
sudo pmset -a standbydelay 0
sudo pmset -a autopoweroff 0

sudo systemsetup -setsleep Off
sudo systemsetup -setcomputersleep Off
sudo systemsetup -setdisplaysleep Off
sudo systemsetup -setharddisksleep Off
sudo systemsetup -setwakeonnetworkaccess Off
sudo systemsetup -setremotelogin Off

# Enable firewall

sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setglobalstate on
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setloggingmode on
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setstealthmode on
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setallowsigned off
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setallowsignedapp off
sudo pkill -HUP socketfilterfw

# Hide administrator user

sudo dscl . create /Users/$admin_user IsHidden 1

# Disable time machine

sudo tmutil disablelocal

# Configure /etc/hosts

curl -L -O https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts
sudo chown root:wheel hosts
sudo chmod 644 hosts
sudo mv hosts /etc/hosts
sudo dscacheutil -flushcache
sudo killall -HUP mDNSResponder

# Configure DNS Servers

sudo networksetup -setdnsservers "Wi-Fi" 8.8.8.8 208.67.222.222

# Disable captive portal

sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.captive.control Active -bool false

# Install Xcode

xcode-select --install

# Install Homebrew

/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew analytics off
echo "export HOMEBREW_NO_INSECURE_REDIRECT=1" >> ~/.bash_profile
echo "export HOMEBREW_CASK_OPTS=--require-sha" >> ~/.bash_profile
echo "export HOMEBREW_NO_ANALYTICS=1" >> ~/.bash_profile

# Install OpenSSL

brew install openssl
echo 'export PATH="/usr/local/opt/openssl/bin:$PATH"' >> ~/.bash_profile

# Install GnuPG

brew install gnupg2

# Install Keepassxc

brew cask install keepassxc

# Install the silver searcher

brew install the_silver_searcher

# Install git

brew install git

# Install iterm2

brew cask install iterm2

# Install jq

brew install jq

# Install Chef development kit

brew cask install chefdk

# Install ZSH

brew install zsh

# Install VIM

brew install vim

# Install curl

brew install curl

# Install atom

brew cask install atom-mac

# Install Node

brew install node

# Install Yarn

brew install yarn

# Install Python

brew install python
brew install python3

# Install Heroku

brew install heroku

# Install VirtualBox

brew cask install virtualbox

# Install Vagrant

brew cask install vagrant

# Install htop

brew install htop

# Install Shell check

brew install shellcheck
