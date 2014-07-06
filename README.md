RetroRig Project for Ubuntu 14.04 LTS
===================================================
![alt text](http://i.imgur.com/Irgv0Fx.png "RetroRig")
###### [Version 0.8.0]

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

You can follow RetroRig's development by staring the github.com page, or by joining the IRC channel `#retrorig-dev`
located under the irc.freenode.net network. The main op is me "ProfessorKaos64". You can also follow me on twitter with the username "@N3RD42". There is also a [forum](http://libregeek.org/forum/index.php) for any and all discussion.

**Please be advised:**      
RetroRig requires sudo access to inject the xboxdrv 
init sripts, install softwate via apt-get, and other 
various items. All script code and config files are 
available for review.

Thank you for your patience.

## Demo Video

[![ScreenShot](http://i.imgur.com/bkSJfPJ.jpg)](https://www.youtube.com/watch?v=W2diF4EJBU4)
[Click here for the version 0.8.0 update video](http://youtu.be/cJxhrWZDrA4)
## Warning

RetroRig is meant to be a standalone setup for XBMC on Ubuntu. Soon, RetorRig will use it's own dotfile so you can continue to use your own XBMC implementation. RetroRig now makes use of a custom-patched XBMC binary as well to allow hotplugging for support controllers is possible. It is mainly targeted at folks wishing to repurpose an old physical PC. VirtualBox support exists, (to an extent), but can behave erratcially with emulator speed/framerates and is not advised. I do hope to corrrect some of that in due time, but right now, it is more of an "extra" or a "test bed."

It is mainly targeted at folks wishing to repurpose an old physical PC. VirtualBox support exists, 
(to an extent), but can behave erratcially with emulator speed/framerates and is not advised. I do
hope to corrrect some of that in due time, but right now, it is more of an "extra" or a "test bed."

It will overwrite some folders for supported emulators and a few system files. Please see the 
wiki entries under "Installation," and "Advanced Configuration," or checkout the source code.

## Some current features include

For all other features and future plans, please see the [wiki](https://github.com/ProfessorKaos64/RetroRig/wiki/Features)

* Custom XBMC home screen and button layout
* Hotplugging support for supported game controllers
* Auto-install software, emulator configs, and required components
* Many supported consoles (more added frequently)
* Gamepad select menu
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
* Uninstall option

## Why XBMC and Ubuntu?

I mainly made the decision to use Ubuntu+XBMC for a few reasons. First of all is XBMC itself, which can
extend far beyond retro gaming, adding many benefits if you decided to utilize XBMC further down the
line, ensuring your computer / partition is not sitting there unused for other tasks. Another reason
was ROM Collection Browser, which in my opinion, is truly amazing at organizing your ROMs. The artwork
scrappers, importers, sorting, filtering, launch options, and more make it truly fantastic.

So then, why Ubuntu? Well, 14.04 LTS recently debuted when I decided to start this, which as many know,
provides years of updates. Additionally, Ubuntu itself is rich with PPAs, software repositories, and
forum documentation. Yes, I could have used many other distributions, but Ubuntu has a wide scope,
and is a hot target for many folks. Arch Linux, or Debian Testing were other considerations. Of course,
there are many pro's and con's to using Ubuntu, all of which are understandable. You can't appease
everyone!

## Wiki

First, I must direct you to read the wiki on this github page, as it contains extra iformation outside this wiki. 
https://github.com/ProfessorKaos64/RetroRig/wiki

**Please also note**  
You may add the `--help` flag to the script for a quick help file. Come on, do it, it has psychedelic colorrrrsss!

## Installation

Pre-requisites:

You will need git,figlet and dialog to run the installer:

    sudo apt-get install dialog git figlet

RetroRig will try to install them for you (for instance, if you download the zip archive), but if you
experience any issues starting the script,enusre they exist with the CLI commands 'which dialog' 
and 'which git" to ensure they report back. Please also ensure your graphics card or onboard graphics chipset supports OpenGL.

To clone this repo via the CLI:

`git clone https://github.com/ProfessorKaos64/RetroRig`

To intstall:
````
cd RetroRig  
sudo ./retrorig_setup.sh
````

You can also download a zip file or by other means on the github page.

## Updating

The config-setup.sh script also currently contains mechanisms to upgrade Ubuntu, update the
emulator binaries, and also a way to pull the latest files from github.

## Please Note

This project is not yet complete! Project notes and guide will be hosted at 
www.libregeek.org at some point in the near future.

# EOF #
