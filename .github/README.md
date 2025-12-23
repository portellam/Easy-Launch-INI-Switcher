<a href="https://github.com/portellam/Easy-Launch-INI-Switcher/releases/latest">
  <img align="left" width="100" height="100" src="../logo.svg" alt="Easy Launch INI Switcher"/>
</a>
<br>

# Easy Launch INI Switcher
An [Aurora](#aurora-dashboard) script to toggle modded Xbox 360 launch configurations.

## 1. How It Works
This is a Lua [utility script]() for the Aurora dashboard on modded Xbox 360 consoles. It allows easy switching between multiple [`launch.ini`]() files (used by [DashLaunch](#dashlaunch) to configure plugins, patches, and boot options) without user input (via file manager or FTP). The script presents a menu to select and apply a predefined `launch.ini` configuration, copying it to the active `launch.ini` location.

## 2. Requirements
- a [software modded]() or [hardware modded]() Xbox 360:
  - [BadUpdate]()
  - [JTAG]()
  - [RGH]()
- a storage device
  - CD/DVD-ROM (not recommended)
  - internal Xbox 360 storage device (typically a hard disk drive or HDD).
  - USB

## 2. Installation
1. Download the [latest release.](https://github.com/portellam/Easy-Launch-INI-Switcher/releases/latest")
2. Extract the script file (typically a `.lua` file) and any supporting files.
3. Copy the script to the Aurora scripts directory: typically `Hdd:\Aurora\User\Scripts\Utility\`.
4. Restart Aurora.
5. Execute the script via the Aurora menu: Press "Back button" > Select *Scripts* > *Utility Scripts.*

## 3. Usage
Launch the script from Aurora's Utility Scripts menu. It will display a list of available configurations. Select one to apply it immediately. The console may need to reboot for changes to take effect (e.g., different plugins or boot paths).

### 1. Configuration
Edit the script's configuration section (or accompanying config file if provided) to define your launch.ini profiles:
- Specify paths to your alternate launch.ini files (e.g., `Hdd:\launch_offline.ini`, `Hdd:\launch_stealth.ini`).
- Add display names for each profile in the menu.
- Set the target path for the active launch.ini (usually root of HDD or USB).

## [4. Contributing](./CONTRIBUTING)

## [5. Contributors](./CONTRIBUTORS)

## 6. Credits
Thanks to the Phoenix team for Aurora and its Lua scripting support.

Inspired by community discussions on [r/360hacks](#r360hacks).

## 7. Contact
[Issues](https://github.com/portellam/issues)

## 8. References
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

## [9. License](../LICENSE)