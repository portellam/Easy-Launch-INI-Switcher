<a href="../../../../releases/latest">
  <img align="left" width="100" height="100" src="../images/logo.png" alt="Easy Launch INI Switcher"/>
</a>
</br>

<h1>
Easy Launch INI Switcher
<a href="https://github.com/portellam/Easy-Launch-INI-Switcher"><img title="GitHub" align="right" height="30" src="../images/github.com.png"/></a>
<a href="https://gitea.com/portellam/Easy-Launch-INI-Switcher"><img title="Gitea" align="right" height="30" src="../images/gitea.com.png"/></a>
<a href="https://codeberg.org/portellam/Easy-Launch-INI-Switcher"><img title="Codeberg" align="right" height="30" src="../images/codeberg.org.png"/></a>
</h1>

An [Aurora Dashboard](../REFERENCES.md/#aurora-dashboard) utility script to toggle modded [Xbox 360](../REFERENCES.md/#xbox-360) launch configurations.
</br>
</br>
Download [here.](../../../../releases/latest)

## 1. How It Works
This is a Lua [utility script](../REFERENCES.md/#aurora-scripts) for the Aurora dashboard on modded Xbox 360 consoles. It allows easy switching between multiple `launch.ini` files without user input (via file manager or FTP). The script presents a menu to select and apply a predefined configuration.

The [database files](../csv/README.md) define all possible config permutations.

The `launch.ini` file is used by [DashLaunch](../REFERENCES.md/#dashlaunch) to configure boot options and plugins.

## 2. Disclaimer
> [!WARNING]
> - Do not go online WITHOUT A STEALTH SERVER. Without a stealth server, the risk of a console and/or account ban IS CERTAIN. With a stealth server, the risk of either ban is low, but NOT ZERO.
> 
> - This software is provided WITHOUT WARRANTY. Any damages caused to your console, personal computer, personal device, or person is YOUR RESPONSIBILITY.
> 
> - This software is FREE. If you paid for it, demand a refund.
> 
> - This software expects dependencies to exist and be found in expected directories. If a dependency cannot be found (does not exist, is in an invalid path, or is mismatched), this may lead to FAILURE or UNEXPECTED BEHAVIOR of the software. 

## [3. Documentation](../LAUNCH-INI-README.md)
Includes [how to information](../LAUNCH-INI-README.md#1-how-to-make-a-launchini), *questions, downloads,* and *more.*

## 4. Requirements
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

## 5. Installation
1. Download the [latest release.](../../../../releases/latest)
2. Extract the script file (typically a `.lua` file) and any supporting files.
3. Copy the script to the Aurora scripts directory: typically `Hdd:\Aurora\User\Scripts\Utility\`.
4. Restart Aurora.

## 6. Usage
### 1. Select a Configuration
1. Launch the script from Aurora's Utility Scripts menu: press "Back button" > select *Scripts* > *Utility Scripts.*
2. Apply a configuration: select one (1) configuration from the list.
3. Reboot the console; some changes will require a reboot to take effect (for example: different plugins or boot paths).

### [2. Define a Configuration](../csv/README.md)

## [7. How to Contribute](./CONTRIBUTING.md)

## [8. Contributors](./CONTRIBUTORS.md)

## 9. Credits
Thanks to the [Pheonix Team](../REFERENCES.md#pheonix-team) for Aurora and its Lua scripting support.

Inspired by community discussions on [r/360hacks](../REFERENCES.md/#r360hacks).

###### [Logo](../REFERENCES.md#logo)

## 10. Contact
Open an [issue](https://gitea.com/portellam/Easy-Launch-INI-Switcher/issues) on the repository.

## 11. Support
[![ko-fi](../images/support_ko-fi.svg)](https://ko-fi.com/portellam)

## [12. References](../REFERENCES.md)

## [13. License](../LICENSE)

#### Click [here](#easy-launch-ini-switcher) to return to the top of this document.