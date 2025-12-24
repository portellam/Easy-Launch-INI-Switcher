<a href="https://github.com/portellam/Easy-Launch-INI-Switcher/releases/latest">
  <img align="left" width="100" height="100" src="../logo.png" alt="Easy Launch INI Switcher"/>
</a>
<h1>Easy Launch INI Switcher</h1><h6>v1.0.0</h6>
</br>
</br>

An [Aurora Dashboard](../REFERENCES.md/#aurora-dashboard) utility script to toggle modded [Xbox 360](../REFERENCES.md/#xbox-360) launch configurations.
</br>
</br>
Download [here.](https://github.com/portellam/Easy-Launch-INI-Switcher/releases/latest)

**View on:** &nbsp;
<a href="https://github.com/portellam/Easy-Launch-INI-Switcher"><img title="GitHub" align="left" height="40" src="../images/github.com.png"/></a>
<a href="https://codeberg.org/portellam/Easy-Launch-INI-Switcher"><img title="Codeberg" align="left" height="40" src="../images/codeberg.org.png"/></a>
<a href="https://gitea.com/portellam/Easy-Launch-INI-Switcher"><img title="Gitea" align="left" height="40" src="../images/gitea.com.png"/></a>
</br>
</br>

## 1. How It Works
This is a Lua [utility script](../REFERENCES.md/#aurora-scripts) for the Aurora dashboard on modded Xbox 360 consoles. It allows easy switching between multiple `launch.ini` files *without user input (via file manager or FTP).* The script presents a menu to select and apply a predefined `launch.ini` configuration, copying it to the active `launch.ini` location.

The `launch.ini` file is used by [DashLaunch](../REFERENCES.md/#dashlaunch) to configure boot options and plugins.

## [2. Documentation](../LAUNCH-INI-README.md)
Documentation regarding anything related to the `launch.ini` configuration file, for a modded Xbox 360. Includes [how to information](../LAUNCH-INI-README.md#1-how-to-make-a-launchini), questions, downloads, and more.

## 3. Requirements
- an Xbox 360 console modified via:
  - [BadUpdate](../REFERENCES.md/#badupdate)
  - [JTAG](../REFERENCES.md/#jtag)
  - [RGH](../REFERENCES.md/#rgh)
- a storage device:
  - CD/DVD-ROM (not recommended)
  - internal Xbox 360 storage device (typically a HDD)
  - USB (HDD or SSD recommended)
- Aurora Dashboard installed.
- DashLaunch installed.

## 4. Installation
1. Download the [latest release.](https://github.com/portellam/Easy-Launch-INI-Switcher/releases/latest)
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
  - Given an HDD, to support Backwards Compatibility and use an [online-only stealth server:](../LAUNCH-INI-README.md/#online-only-stealth-servers) `Hdd:\launch.ini.d\launch_ogxbox-compat_online-stealth-server.ini`
- Add a display name for the new profile in the menu.
- Set the target path for the active `launch.ini`, typically the root directory (see [Supported Device Paths](../REFERENCES.md/#2-supported-device-paths)).

### 2. Supported Device Paths
```
; internal hard disk    Hdd:\
; usb memory stick      Usb:\
; memory unit           Mu:\
; USB memory unit       UsbMu:\
; big block NAND mu     FlashMu:\
; internal slim 4G mu	IntMu:\
; internal corona 4g mu MmcMu:\
```

## [6. How to Contribute](./CONTRIBUTING.md)

## [7. Contributors](./CONTRIBUTORS.md)

## 8. Credits
Thanks to the Phoenix team for Aurora and its Lua scripting support.

Inspired by community discussions on [r/360hacks](../REFERENCES.md/#r360hacks).

## 9. Contact
Open an [issue](https://github.com/portellam/Easy-Launch-INI-Switcher/issues) on the repository.

## 10. Support
[![ko-fi](../support_ko-fi.svg)](https://ko-fi.com/portellam)

## [11. References](../REFERENCES.md)

## [12. License](../LICENSE)

##

#### Click [here](#easy-launch-ini-switcher) to return to the top of this document.