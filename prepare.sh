#!/bin/bash

# lunasky/macdeploy | Luna | 2023
# prepare.sh | Prepare and Verify all necessary requirements are met before setup.
# pls ignore the jank, this is all thrown together with 0 sleep <3

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
  echo "Please update to macOS 12.4 or later."          # "weewoo you have old macos!!11!"
  exit 1
else
  echo "You are running macOS "$(sw_vers -productVersion)", proceeding."
fi