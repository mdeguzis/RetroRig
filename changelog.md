RetroRig changelog
============================

Version 0.8.0

* Uninstall option fixes
* New and improved logging options (xbmc logging while in RetroRig)
* Establish beta branch
* Cusomt/Patched version of XBMC with hotplugging gamepad support for XBMC (Thanks JC!!!)
* PS3 Controller support (bluetooth)
* Xbox 360 Controller support (USB)
* Additional emulator support:    
  GBC
  GBA
  TurboGraphx 16
  Neo-Geo CDZ
  Sega Game Gear
  PSP
  Sega Genesis
* Many bug fixes
* Larger binary files hosted at libregeek.org
* Control/Gamepad assignement fixes (refinement over time)


Version 0.7.0
-------------

- Global Resolution selection for current emulators that support it  
- Fix script menu appearance  
- ROM loader during configuration and in settings menu  
- Establish testing snapshot on Vbox running Ubuntu 14.04 LTS  
- Finish folder skelton  
- Install progress bars  
- Verify required config files for current emulators in XBMC  
- Replace specifc /home/test/ defaykt user with current user's home path.  
- Roll out and test 0.6a release on VM  
- Ensure dependencies are met  
- Autostart XBMC via config file  
- Autostart Rom Collection Browser in XBMC (software limitation, working with RCB dev)  
- mechanism to update git repo in script  
- test all emulators with sample ROM  
- import games from folder on startup to avoid manual intervention (RCB menu pop, with cancel)  


Release 0.6.2
-------------

- Global Resolution selection for emulators that support it (in progress)
- Custom resolution
- Fix script menu appearance
- Establish testing snapshot on Vbox running Ubuntu 14.04 LTS
- Complete folder skeleton for game ROMs, Artwork, Saves
- Add any game to an appropriate ROM folder and run RCB's import tool and you're good to go!
- Prebuilt config files for emulators mapped to Xbox wireless controller (spot checking ongoing)
- Dependencies are auto installed
- XBMC autostarts directly into Rom Collection Browser
- Rom Collection browser will prompt for games to import on first run
- Mechanisms to update github repo in the install script itself
