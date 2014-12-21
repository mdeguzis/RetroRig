RetroRig Project
===================================================
![alt text](http://i.imgur.com/Irgv0Fx.png "RetroRig")
###### [Version 0.9.8]

RetroRig is shell script to setup a Linux x86_64 system  with several emulators, and XBMC as graphical
front end.The inspiration for doing this lies almost completely with the RetroPie Project. I wanted to provide
something similar, but with XBMC, x86_64, and my favorite interface, "Rom Collection Browser."
This project is intended to be run on Ubuntu (currently 14.04 LTS), and a gamepad / controller.
At some point in the future, I want to try and branch this to other distributions if possible. 
Please see the features page on the wiki for ideas and future plans.

I invite you to challenge the configs and scripts to help improve my ultimate goal to provide
an easy way to get up and running with RetroGaming on x86_64 Linux systems. Pull requests or
Issues are very much welcome! Please see the AUTHORS file in the root directory for all the awesome people
that contribute to this project.

You can follow RetroRig's development by staring the github.com page, or with joining the IRC channel `#retrorig-dev`
located under the irc.freenode.net network. The main op is me "ProfessorKaos64". You can also follow me on twitter with the username "@N3RD42". There is also a [forum](http://libregeek.org/forum/index.php) for any and all discussion.

**Please be advised:**      
RetroRig requires sudo access to inject the xboxdrv 
init sripts, install softwate via apt-get, and other 
various items. All script code and config files are 
available for review.

Thank you for your patience.

## Demo Video

[![ScreenShot](http://i.imgur.com/CTrQIKI.png)](https://www.youtube.com/watch?v=G49MMQi2zHE)

## Warning

RetroRig was originally meant to be a standalone setup for XBMC on Ubuntu from bootup to shutdown. If you wish to launch RetroRig on your own, simply remove the autostart entry. RetorRig uses it's own dotfile so you can continue to use your own XBMC implementation. RetroRig now makes use of a custom-patched XBMC binary as well to allow hotplugging for support controllers is possible, as well as proper dual monitor support. It is mainly targeted at folks wishing to repurpose an old physical PC. I do hope to corrrect some of that in due time, but right now, it is more of an "extra" or a "test bed."

RetroRig implements a separated ".xbmc" configuration folder, however, we do not have separated xbmc itself. RetroRig will upgrade XBMC to the latest Helix (Now called Kodi). It is paramount to check in advance, if all your regular xbmc plugins, skins, etc. still work under Helix. 

This is mainly targeted at folks wishing to repurpose a spare physical PC. VirtualBox support exists, 
(to an extent), but can behave erratcially with emulator speed/framerates and is not advised. I do
hope to corrrect some of that in due time, but right now, it is more of an "extra" or a "test bed." 
RetroRig will overwrite some folders for supported emulators and a few system files. Please see the 
wiki entries under "Installation," and "Advanced Configuration," or checkout the source code.

## Some current features include

For all other features and future plans, please see the [wiki](https://github.com/ProfessorKaos64/RetroRig/wiki/Development-and-Features)

* Concentration on a console-like experience from bootup to shutdown
* No need to install an entire separate distro on your Mint/Debian machine
* Custom XBMC, emulator, utilties packages
* Custom XBMC home screen and button layout
* Seperate dot file (.retrorig, not .xbmc) so you can have your cake and eat it too!
* Hotplugging support for supported wireles game controllers
* Dual monitor support for XBMC
* Steam (Big Picture Mode) launcher from the main screen
* Auto-install software, emulator configs, and required components
* Many supported consoles (more added frequently)
* Gamepad select menu
* SSH and samba share support
* Preset Controller mappings for supported gamepads
* Resolution presets/custom selection for emulators that support it
* Save state, load state, exit emulators with gamepad
* A cobbled together "first run" state of RCB with a blank games database and pre-set configs
* Functions to update git repo, emulator binaries, upgrade system and more
* Automatically start XBMC, then directly into RCB itself (option to boot to XBMC session in settings menu)
* ROM pre-loader
* BIOS pre-loader
* Modular design for expandability
* Unity configuration set during config-setup to lengthen screen timeout + remove screen lock

## Wiki

First, I must direct you to read the wiki on this github page, as it contains extra information outside this wiki. A large amount of tips, tricks, and how-to information is located on this, all for your benefit.
https://github.com/ProfessorKaos64/RetroRig/wiki

**Please also note**  
You may add the `--help` flag to the script for a quick help file. Come on, do it, it has psychedelic colorrrrsss!

## Installation

Pre-requisites:

You will need git, dialog to run the installer and for updating:

    sudo apt-get install dialog git

RetroRig will try to install them automatically for you (for instance, if you download the zip archive), but if you
experience any issues starting the script,enusre they exist with the CLI commands 'which dialog' 
and 'which git" to ensure they report back. Please also ensure your graphics card or onboard graphics chipset supports OpenGL. 
All install commands below are done on the command line. You can however doubleclick on the Debian package to install it.

##### Preferred method: package installation

```
sudo add-apt-repository ppa:mdeguzis/retrorig
sudo apt-get update
sudo apt-get install retrorig-setup
sudo retrorig-setup
```

Pre-built packages for other distributions will be coming in the future. Stay tuned.

##### Alternate install method (GitHub source):

`git clone https://github.com/ProfessorKaos64/RetroRig`

To install via GitHub source:
````
cd RetroRig
sudo ./retrorig_setup.sh
````

The main disitribution target is Ubuntu 14.04 LTS, but support for other platforms is being worked on. For a currernt list of supported platofrms and distributions, see [this](https://github.com/ProfessorKaos64/RetroRig/wiki/Installation#platforms) wiki entry. You can also perform a `git checkout Beta` to try our Beta branch, but please do so with caution and backup any file before hand!

You can also download a zip file or by other means on the github page.

## Updating

The retrorig-setup.sh script also currently contains mechanisms to upgrade Ubuntu, update the
emulator binaries, update our patched XBMC version, and also a way to pull the latest files from github. 

## Please Note

This project is not yet complete! Project notes and guide will be hosted at 
www.libregeek.org at some point in the near future.

# EOF #
