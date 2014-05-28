RetroRig Project for Ubuntu 14.04 LTS
===================================================
###### [Version 0.7.3]

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

-Emulator configs for supported emulators:

* ZSNES
* Nestopia
* Gens/GS
* MAME
* Stella
* Mupen64Plus
* PCSX
* PCSX2
* Dolphin
* mednafen (GBC currently)

-Also configs related to:

* qjoypad
* Blacklisting xpad
* Autostarted application entries (XBMC, qjoypad)
* Some folder structures under ~/Games
* xboxdrv init scripts and configurations

## Current feature set

* Auto-install software, emulator configs, and required components
* (settings menu) 4-player wireless xboxdrv userland module inserted as init script
* (settings menu) Gamepad select menu
* (settings menu) Resolution presets/custom selection for emulators that support it
* Preset Controller mappings for supported gamepads
* Save state, load state, exit emulators with gamepad (pcsx, pcsx2 have issues currently)
* A cobbled together "first run" state of RCB with a blank games database and pre-set configs
* Functions to update git repo, emulator binaries, upgrade system and more
* MAME offline scrapper system built in (artwork almost ready)
* Automatically start XBMC, then directly into RCB itself
* ROM pre-loader on configuration setup
* Logging options for install
* Unity configuration set during config-setup to lengthen screen timeout + remove screen lock
* Beta branch for those wishing to see/test what I'm working on
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

## Controller Setup:

I Tried to reflect the original controller as much as possible for some such as the NES and SNES. The
save/load/exit button assignments are constant for all emulators except pcsx and pcsx2 (working on it!). In due time I will add more, with the next being the Dualshock 2/3 controller.

Please see controller-cfg-list.txt for the complete set!

Current supported controllers:

* Xbox 360 Controller (wireless)
* Xbox 360 Controller (wired) 

## ROMs

It is a good idea to load games before hand into the predefined folders after the configuration option is ran and you reboot your PC. On first startup Rom Collection Browser will ask for games to import. Several emulators are supported and built in for easy importing.ROMs for emualtors are NOT provided for legal reasons. Due to legal gray areas with BIOS files, they will not be provided for emulators that require them (e.g. pcsx, pcsx2).Please do not request these items be added.

Currently importing ROMs into XBMC is a keyboard-less affair for the following consoles:

* SNES
* NES
* Sega Genesis
* MAME
* Atari 2600
* Nintendo 64
* Playstation 1
* Playstation 2
* Gamecube
* Gameboy Color

All ROMs should be placed in the respective folder under "/home/$USER/Games/ROMs". In due time, I will
add more and more emulators. But until then, you can manually add them. In a later release, I plan on
building in a text-based file browser to locate and import games. For now, you must copy them in the
folders under ~/Games. In the near future, I will load Samba for file transfers as optional
install items (SSH is now in).

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
    ./config-setup.sh

sudo access is needed for updates, installs, and folder creation. If you wish, you can review the script
code beforehand to see what sudo does.You can also choose to just copy configuration filesfrom each 
folder if you wish to just steal some notes on how to setup the emulators. Please reference the issues
area on Github for current issues, or the release-roadmap for upcoming items.

You can also download a zip file or by other means on the github page.

## Updating

The config-setup.sh script also currently contains mechanisms to upgrade Ubuntu, update the
emulator binaries, and also a way to pull the latest files from github.

## Please Note

This project is not yet complete!

Project notes and guide will be hosted at www.libregeek.org at some point in the near future.

## A big thanks goes out to

<b>Software binaries:</b>  
The authors of XBMC, Rom Collection Browser, and the various emulators in use here.  

<b>Help and Configuration </b>  
The great folks of #linuxactionshow (Geekshed IRC)  
All the members of #bash (freenode.net IRC)  
All the members of /r/LinuxActionShow  

# EOF #
