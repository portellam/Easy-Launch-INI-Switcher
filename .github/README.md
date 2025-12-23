<a href="https://github.com/portellam/Easy-Launch-INI-Switcher/releases/latest">
  <img align="left" width="100" height="100" src="../logo.svg" alt="Easy Launch INI Switcher"/>
</a>
<br>

# Easy Launch INI Switcher
An [Aurora Dashboard](#aurora-dashboard) utility script to toggle modded [Xbox 360](#xbox-360) launch configurations.

## 1. How It Works
This is a Lua [utility script]() for the Aurora dashboard on modded Xbox 360 consoles. It allows easy switching between multiple [`launch.ini`]() files (used by [DashLaunch](#dashlaunch) to configure boot options and plugins) without user input (via file manager or FTP). The script presents a menu to select and apply a predefined `launch.ini` configuration, copying it to the active `launch.ini` location.

## 2. Why?
Given the various dashboards and plugins (patches, [stealth servers](), etc.) available, some of these may conflict: with either each other, or Xbox 360 system features, such as [Backwards Compatibility](). For more information, please read the related [documentation.](../LAUNCH-INI-PERMUTATIONS.md)

## 3. Requirements
- An Xbox 360 console modified via:
  - [BadUpdate](#badupdate)
  - [JTAG](#jtag)
  - [RGH](#rgh)
- a storage device:
  - CD/DVD-ROM (not recommended)
  - internal Xbox 360 storage device (typically a hard disk drive or HDD).
  - USB (HDD or solid state drive (SSD) recommended)
- Aurora Dashboard installed
- DashLaunch installed

## 4. Installation
1. Download the [latest release.](https://github.com/portellam/Easy-Launch-INI-Switcher/releases/latest")
2. Extract the script file (typically a `.lua` file) and any supporting files.
3. Copy the script to the Aurora scripts directory: typically `Hdd:\Aurora\User\Scripts\Utility\`.
4. Restart Aurora.

## 5. Usage
1. Launch the script from Aurora's Utility Scripts menu: press "Back button" > select *Scripts* > *Utility Scripts.*
2. Apply a configuration: select one (1) configuration from the list.
3. Reboot the console; some changes will require a reboot to take effect (for example: different plugins or boot paths).

### 1. Configuration
Edit the script's configuration section (or related config file if provided) to define `launch.ini` profiles:
- Specify the path to your alternate `launch.ini` file.
  - Given an HDD, to support Backwards Compatibility and use an online-only stealth servers: `Hdd:\launch.ini.d\launch_ogxbox-compat_online-stealth-server.ini`
- Add a display name for the new profile in the menu.
- Set the target path for the active `launch.ini`, typically the root directory (see [Supported Device Paths](#2-supported-device-paths)).

### 2. Supported Device Paths
```
; internal hard disk    Hdd:\
; usb memory stick      Usb:\
; memory unit           Mu:\
; USB memory unit       UsbMu:\
; big block NAND mu     FlashMu:\
; internal slim 4G mu	IntMu:\
; internal corona 4g mu MmcMu:\
; CD/DVD                Dvd:\  
```

## [6. Contributing](./CONTRIBUTING)

## [7. Contributors](./CONTRIBUTORS)

## 8. Credits
Thanks to the Phoenix team for Aurora and its Lua scripting support.

Inspired by community discussions on [r/360hacks](#r360hacks).

## 9. Contact
[Issues](https://github.com/portellam/issues)

## 10. References
### Aurora Dashboard
&nbsp;&nbsp;**Aurora | ConsoleMods Wiki**. ConsoleMods. Accessed 2025-12-23.

<sup>&nbsp;&nbsp;&nbsp;&nbsp;Original:&nbsp;</sup>
<sup>https://consolemods.org/wiki/Xbox_360:Aurora.</sup>

<sup>&nbsp;&nbsp;&nbsp;&nbsp;Archive:&nbsp;</sup>
<sup></sup>

### DashLaunch
&nbsp;&nbsp;**DashLaunch | ConsoleMods Wiki**. ConsoleMods. Accessed 2025-12-23.

<sup>&nbsp;&nbsp;&nbsp;&nbsp;Original:&nbsp;</sup>
<sup>https://consolemods.org/wiki/Xbox_360:DashLaunch.</sup>

<sup>&nbsp;&nbsp;&nbsp;&nbsp;Archive:&nbsp;</sup>
<sup></sup>

### r/360hacks
&nbsp;&nbsp;**Hacks and Mods for the Xbox 360!**. ConsoleMods. Accessed 2025-12-23.

<sup>&nbsp;&nbsp;&nbsp;&nbsp;Original:&nbsp;</sup>
<sup>https://www.reddit.com/r/360hacks.</sup>

<sup>&nbsp;&nbsp;&nbsp;&nbsp;Archive:&nbsp;</sup>
<sup></sup>

&nbsp;&nbsp;**Easy ways to swap launch.ini? : r/360hacks**. ConsoleMods. Accessed 2025-12-23.

<sup>&nbsp;&nbsp;&nbsp;&nbsp;Original:&nbsp;</sup>
<sup>https://www.reddit.com/r/360hacks/comments/177z2fv/easy_ways_to_swap_launchini.</sup>

<sup>&nbsp;&nbsp;&nbsp;&nbsp;Archive:&nbsp;</sup>
<sup></sup>

## [11. License](../LICENSE)