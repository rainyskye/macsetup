# macsetup
![Written in Bash](https://img.shields.io/badge/written%20in-Bash-blueviolet)
![GitHub License](https://img.shields.io/github/license/lunaskyy/macsetup)

***Please note: This project is mainly for personal use, feel free to fork the repo and change everything necessary to match your preferences, but I won't offer support/feature requests, it is all written in bash to make it easy to tack on extra features, etc. The code is all commented "fairly" well, so it should be easy to figure out what does what.***

## Things to implement/improve:
- [x] Automatically Install [brew.sh](https://brew.sh) if it's not already installed.
- [ ] *(In-Progress)* Automatically install configure CLI tools (e.g: Git, macchina, etc.)
- [x] Setup Finder with custom settings (e.g: Show Hidden Files, Show all File extensions, etc.)
- [x] Set Wallpaper automatically
- [ ] Configure Dock items automatically
- [ ] Set Lock Screen text ("Authorised use only, etc.")

## How to run
Just run the script by copying below and pasting into the terminal.

Please note that you should **always** check scripts before you run them on your device.

```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/lunaskyy/macsetup/main/setup.sh)"
```

## Downloading Mac App Store apps
Due to some interesting changes made by Apple, the `mas` tool used by the macsetup scripts have broken some features, the `signin`, `purchase` and `account` commands have all been broken in macOS 10.13, 10.15 and 12 respectfully.

This will limit some automation of the script, you will need to pre "purchase" the apps from the mac app store prior to using the script to install the apps, this will then apply the licence to your account (even if it's a free app), to allow you to install the apps in the future unattended.