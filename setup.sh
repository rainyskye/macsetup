#!/bin/bash

# lunasky/macdeploy | Luna | 2023
# prepare.sh | Prepare and Verify all necessary requirements are met before setup.
# pls ignore the jank, this is all thrown together with 0 sleep <3

D="[DEBUG] "
I="[INFO] "
P="[PASS] "
W="[WARNING] "
E="[ERROR] "
F="[FATAL] "

red=`tput setaf 1`
green=`tput setaf 2`
yellow=`tput setaf 3`
blue=`tput setaf 4`
pink=`tput setaf 5`
cyan=`tput setaf 6`
white=`tput setaf 7`
reset=`tput sgr0`

# Flags for testing, etc.
DEBUG=true           # May be used to enable/disable messages for testing.
INTERACTIVE=false    # TODO: Add ability to interact with script (e.g: choose whether to install missing deps or exit)
YELL=false           # TODO: Use 'say' to alert user of errors, user input required, or completion.
WHEREAREWE=$(pwd)

# Programs and stuff
INSTALL_BREW=false

# If debug is enabled, print information about the machine.
if $DEBUG = true
then
  echo $D"Debugging is on, will print a lot of information about the machine."
  echo $D"System architecture is "$(uname -m)", CPU model is "$(sysctl -n machdep.cpu.brand_string)
  echo $D"Hostname is "$(sysctl -n kern.hostname)
  echo $D"Running macOS "$(sw_vers -productVersion)", build "$(sw_vers -buildVersion)
  echo $D"Running in "$WHEREAREWE
fi

# Hello message
echo "
-------------------------------------------------------"
echo "
                         __             __             
 .--------.---.-.----.--|  .-----.-----|  .-----.--.--.
 |        |  _  |  __|  _  |  -__|  _  |  |  _  |  |  |
 |__|__|__|___._|____|_____|_____|   __|__|_____|___  |
                                 |__|           |_____|"
echo "
-------------------------------------------------------"
echo "------------ days without explosions > [0] ------------"
echo "-------------------------------------------------------"

# Convert version strings into plain integer - thamk stack overflow <3
function versionToInt() {
  local IFS=.
  parts=($1)
  let val=1000000*parts[0]+1000*parts[1]+parts[2]
  echo $val
}

# Check macOS Version and ensure it's 12.4 or higher
OS_RUNNING=$(versionToInt $(sw_vers -productVersion))   # Get Current macOS Version
OS_REQUIRED=$(versionToInt 12.4)                        # Minumum macOS Version
if [ $OS_RUNNING \< $OS_REQUIRED ]; then
  echo $E"Please update to macOS 12.4 or later."        # "weewoo you have old macos!!11!"
  exit 1
else
  echo $I"You are running macOS "$(sw_vers -productVersion)", proceeding."
fi

# Check if brew is installed, and set it to be installed if it isn't.
if ! command -v brew &> /dev/null
then
  echo $W"Brew wasn't found, and is required for setup, will add to the install queue."
  INSTALL_BREW=true
else
  read -r -p "Brew was found, do you want to update and upgrade all packages? [y/N] " response
  if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]
  then
      brew update     # Update repos
      brew upgrade    # Upgrade Packages
      brew cleanup    # Cleanup old packages
  fi
fi

# Install brew if not already installed
if $INSTALL_BREW = true
then
  echo $I"Installing brew from 'brew.sh' - Installer will ask for your sudo password."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" NONINTERACTIVE=1
  if [ $? -eq 0 ];                                                                          # Check if Homebrew installed properly
  then 
    echo $I"Homebrew successfully installed."                                               # Homebrew Install Succeeded
  else 
    echo $F"Homebrew install may have failed. Check above for more information, exiting."   # Homebrew Install Failed
    exit 1
  fi
  echo '# Set PATH, MANPATH, etc., for Homebrew.' >> /Users/luna/.zprofile        # Assuming ZSH - if not using ZSH, cry?
  echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> /Users/luna/.zprofile       # Assuming ZSH - if not using ZSH, cry?
  eval "$(/opt/homebrew/bin/brew shellenv)"                                       # Assuming ZSH - if not using ZSH, cry?
  brew analytics off                                                              # Disable brew analytics
fi

defaults write com.apple.finder _FXShowPosixPathInTitle -bool true
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
defaults write com.apple.Finder AppleShowAllFiles true
killall Dock; killall Finder

# Install required cli utilities with brew
brew install m-cli macchina 

### Install Mac App Store apps - use `mas search ____` to find app ids
brew install mas
mas install 1451685025  # wireguard
mas install 497799835   # xcode
mas install 640199958   # apple developer
mas install 899247664   # testflight

### Install some apps from homebrew casks

# macs-fan-control
brew install --cask macs-fan-control

# google-chrome
brew install --cask google-chrome

# 1password
brew install --cask 1password

# android-platform-tools
brew install --cask andorid-platform-tools

# balenaetcher
brew install --cask balenaetcher

# blender
brew install --cask blender

# burp-suite
brew install --cask burp-suite

# caffeine
brew install --cask caffeine

# cyberduck
brew install --cask cyberduck

# spotify
brew install --cask spotify

# visual-studio-code
brew install --cask visual-studio-code

# Cope macchina config
mkdir -p ~/.config/macchina/    # Create macchina config folder
cp -r $WHEREAREWE/configs/macchina/* ~/.config/macchina/

# Pull and set wallpaper from wallpaper folder
cp $WHEREAREWE/wallpaper/wallpaper.jpeg ~/.config/wallpaper.jpeg
m wallpaper ~/.config/wallpaper.jpeg
