# OSX

## Administrator setup

Set computer hostname:

```
sudo scutil --set ComputerName  $hostname
sudo scutil --set LocalHostName $hostname
```

Do not keep Filevault key on standby:

```
sudo pmset -a destroyfvkeyonstandby 1
```

Do not hybernate:

```
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
```

Disable remote login:

```
sudo systemsetup -setremotelogin Off
```

Enable firewall:

```
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setglobalstate on
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setloggingmode on
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setstealthmode on
sudo pkill -HUP socketfilterfw
```

Disable signed software to be allowed automatically:

```
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setallowsigned off
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setallowsignedapp off
```

Hide administrator user:

```
ADMINISTRATOR_USER=$(whoami) && sudo dscl . create /Users/${ADMINISTRATOR_USER} IsHidden 1
```

Download and replace `/etc/hosts` with the latest version of [this file](https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/fakenews-gambling-porn-social/hosts).

Clear DNS cache:

```
sudo killall -HUP mDNSResponder
```

Configure DNS servers:

```
sudo networksetup -setdnsservers "Wi-Fi" 8.8.8.8 8.8.4.4
```

Disable captive portal:

```
sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.captive.control Active -bool false
```

Install Xcode:

```
xcode-select --install
```

Install Homebrew:

```
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew analytics off
echo "export HOMEBREW_NO_INSECURE_REDIRECT=1" >> ~/.bash_profile
echo "export HOMEBREW_CASK_OPTS=--require-sha" >> ~/.bash_profile
echo "export HOMEBREW_NO_ANALYTICS=1" >> ~/.bash_profile
```

See [brew.sh](https://brew.sh) for latest instructions.

Install essential applications:

```
brew install zsh \
             vim \
             curl \
             rsync \
             git \
             the_silver_searcher \
             fzf \
             bat \
             prettyping \
             diff-so-fancy \
             fd \
             ncdu \
             tldr \
             jq \
             htop \
             shellcheck

brew install --cask iterm2 \
                    keepassxc \
                    osxfuse \
                    cryptomator \
                    visual-studio-code \
                    docker
```

## User setup

Hide media from Desktop:

```
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool false
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool false
killall -HUP Finder
```

Install oh-my-zsh:

```
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
```

Install JetBrains Mono font:

https://www.jetbrains.com/lp/mono/

## Spotlight fix

```
touch /Applications/Xcode.app
```

> System Preferences > Spotlight > Search Results > Developer (uncheck)

## Catalina ITerm2 permissions fix

You can grant ITerm2 full disk access temporarily to make system changes:

> System Preferences > Security & Privacy > Full Disk Access > + > iTerm

corespeechd is sending a massive amount to data to Internet

1. System Preferences -> Accessibility -> Siri
2. Click “Open Siri Preferences...”
3. Check the box for “Enable Ask Siri”
4. Move the radio button for “Voice Feedback” to “Off”
5. Uncheck “Enable Ask Siri”
