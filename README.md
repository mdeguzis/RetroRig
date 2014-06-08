RetroRig Project for Ubuntu 14.04 LTS
===================================================
![alt text](http://i.imgur.com/Irgv0Fx.png "RetroRig")
###### [Version 0.7.7]

RetroRig is shell script to setup a Linux x86_64 system  with several emulators, and XBMC as graphical
front end.The inspiration for doing this lies almost completely with the RetroPie Project. I wanted to provide
something similar, but with XBMC, x86_64, and my favorite interface, "Rom Collection Browser."
This project is intended to be run on Ubuntu (currently 14.04 LTS) with an wireless Xbox 360 Controller.
At some point in the future, I want to try and branch this to other distributions if possible, as well
as accomodate other controllers. Please see the release-roadmap file for ideas and future plans.

I invite you to challenge the configs and scripts to help improve my ultimate goal to provide
an easy way to get up and running with RetroGaming on x86_64 Linux systems. Pull requests or
Issues are very much welcome!

Thank you for your patience.

## Warning

RetroRig is meant to be a standalone setup for XBMC on Ubuntu
It is mainly targeted at folks wishing to repurpose an old PC.

Warning! It will overwrite:

-Emulator configs for supported emulators (see "Section 1: Installation" of the wiki)  
-Also configs related to:  

* qjoypad
* Blacklisting xpad
* Autostarted application entries (XBMC, qjoypad)
* Some folder structures under ~/Games
* xboxdrv init scripts and configurations

## Some current features include

For all other features, please see the [wiki](https://github.com/ProfessorKaos64/RetroRig/wiki)

* Auto-install software, emulator configs, and required components
* Many supported consoles (more added frequently)
* Gamepad select menu
* Resolution presets/custom selection for emulators that support it
* Preset Controller mappings for supported gamepads
* Save state, load state, exit emulators with gamepad
* A cobbled together "first run" state of RCB with a blank games database and pre-set configs
* Functions to update git repo, emulator binaries, upgrade system and more
* Automatically start XBMC, then directly into RCB itself (option to boot to XBMC session in settings menu)
* ROM pre-loader
* BIOS pre-loader
* A super lame logo on startup!
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

You will need git and dialog to run the installer:

    sudo apt-get install dialog git

RetroRig will try to install them for you (for instance, if you download the zip archive), but if you
experience any issues starting the script,enusre they exist with the CLI commands 'which dialog' 
and 'which git" to ensure they report back.

To clone this repo via the CLI:

`git clone https://github.com/ProfessorKaos64/RetroRig`

To intstall:

    cd RetroRig  
    sudo ./config-setup.sh

You can also download a zip file or by other means on the github page.

## Updating

The config-setup.sh script also currently contains mechanisms to upgrade Ubuntu, update the
emulator binaries, and also a way to pull the latest files from github.

## Please Note

This project is not yet complete! Project notes and guide will be hosted at 
www.libregeek.org at some point in the near future.

## A big thanks goes out to

<b>Software binaries:</b>  
The authors of XBMC, Rom Collection Browser, and the various emulators in use here.  

<b>Help and Configuration </b>  
The great folks of #linuxactionshow (Geekshed IRC)  
All the members of #bash (freenode.net IRC)  
All the members of /r/LinuxActionShow  

# EOF #
