#!/bin/bash

# lunasky/macdeploy | Luna | 2023
# prepare.sh | Prepare and Verify all necessary requirements are met before setup.
# pls ignore the jank, this is all thrown together with 0 sleep <3

D="[DEBUG] "
I="[INFO] "
E="[ERROR] "
P="[PASS] "
W="[WARNING] "

# Flags for testing, etc.
DEBUG=true           # May be used to enable/disable messages for testing.
INTERACTIVE=false    # TODO: Add ability to interact with script (e.g: choose whether to install missing deps or exit)
YELL=false           # TODO: Use 'say' to alert user of errors, user input required, or completion.

# Programs and stuff
INSTALL_BREW=false

# If debug is enabled, print information about the machine.
if $DEBUG = true
then
  echo $D"Debugging is on, will print a lot of information about the machine."
  echo $D"System architecture is "$(uname -m)", CPU model is "$(sysctl -n machdep.cpu.brand_string)
  echo $D"Hostname is "$(sysctl -n kern.hostname)
  echo $D"Running macOS "$(sw_vers -productVersion)", build "$(sw_vers -buildVersion)
fi

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
    echo $W"brew wasn't found, and is required for setup, will add to the install queue."
    INSTALL_BREW=true
fi