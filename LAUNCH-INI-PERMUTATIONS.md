# Xbox 360 Launch INI Permutations
Permutations for subjective experiences on a modded Xbox 360 (configurations of the [launch.ini](#launchini)), and related documentation.

## 1. How to Reference This Document

1. Given a `launch.ini`, specify a master copy file with the following settings: [Non-Permutations](#3-non-permutations)
2. Create permutations for different use cases. Please reference the following:
	1. [File Paths](#file-paths)
	2. [Permutations](#2-permutations)
	3. [`[Plugins]`](#plugins)
3. For questions, review [Definitions](#4-definitions).

## 2. Permutations

### Custom Dashboards

| Use Case                                                                 | Primary Dashboard                            | Secondary Dashboard | Dashboard: ConfigApp | Plugin: Stealth Servers         | Block Xbox Live | Requires Internet connection                             | Works?          |
| ------------------------------------------------------------------------ | -------------------------------------------- | ------------------- | -------------------- | ------------------------------- | --------------- | -------------------------------------------------------- | --------------- |
| **No** [Xbox Live Access](#xbox-live-access) + **Yes** [Original Xbox Compatibility](#original-xbox-compatibility)  | [Metro](#metro)                         | **Primary**         | **Primary**          | [Cipher](#cipher) or NULL       | True            | Maybe: [Online-Only Stealth Servers Positive Matches](#online-only-stealth-servers-positive-matches) | Confirmed true. |
| **No** [Xbox Live Access](#xbox-live-access) + **Yes** [Original Xbox Compatibility](#original-xbox-compatibility)  | Aurora                                       | **Primary**         | [Metro](#metro)         | [Cipher](#cipher) or NULL       | True            | Maybe: [Online-Only Stealth Servers Positive Matches](#online-only-stealth-servers-positive-matches) | Confirmed true. |
| **No** [Xbox Live Access](#xbox-live-access) + **Yes** [Original Xbox Compatibility](#original-xbox-compatibility)  | [Kinect / NXE V2](#kinect--nxe-v2)       | **Primary**         | **Primary**          | [Cipher](#cipher)               | True            | True: [Online-Only Stealth Servers Positive Matches](#online-only-stealth-servers-positive-matches)  | TODO            |
| **No** [Xbox Live Access](#xbox-live-access) + **Yes** [Original Xbox Compatibility](#original-xbox-compatibility)  | [New Xbox Experience (NXE) V1](#new-xbox-experience-nxe-v1) | **Primary**         | **Primary**          | [Cipher](#cipher)               | True            | True: [Online-Only Stealth Servers Positive Matches](#online-only-stealth-servers-positive-matches)  | TODO            |
| **No** [Xbox Live Access](#xbox-live-access) + **Yes** [Original Xbox Compatibility](#original-xbox-compatibility)  | [Blades](#1-blades)                       | **Primary**         | **Primary**          | [Cipher](#cipher)               | True            | True: [Online-Only Stealth Servers Positive Matches](#online-only-stealth-servers-positive-matches)  | TODO            |
| **Yes** [Xbox Live Access](#xbox-live-access) + **Yes** [Original Xbox Compatibility](#original-xbox-compatibility) | [Metro](#metro)                         | **Primary**         | **Primary**          | [Cipher](#cipher)               | False           | True: [Online-Only Stealth Servers Positive Matches](#online-only-stealth-servers-positive-matches)  | Confirmed.      |
| **Yes** [Xbox Live Access](#xbox-live-access) + **Yes** [Original Xbox Compatibility](#original-xbox-compatibility) | Aurora                                       | **Primary**         | [Metro](#metro)         | [Cipher](#cipher)               | False           | True: [Online-Only Stealth Servers Positive Matches](#online-only-stealth-servers-positive-matches)  | TODO            |
| **Yes** [Xbox Live Access](#xbox-live-access) + **Yes** [Original Xbox Compatibility](#original-xbox-compatibility) | [Kinect / NXE V2](#kinect--nxe-v2)       | **Primary**         | **Primary**          | [Cipher](#cipher)               | False           | True: [Online-Only Stealth Servers Positive Matches](#online-only-stealth-servers-positive-matches)  | TODO            |
| **Yes** [Xbox Live Access](#xbox-live-access) + **Yes** [Original Xbox Compatibility](#original-xbox-compatibility) | [New Xbox Experience (NXE) V1](#new-xbox-experience-nxe-v1) | **Primary**         | **Primary**          | [Cipher](#cipher)               | False           | True: [Online-Only Stealth Servers Positive Matches](#online-only-stealth-servers-positive-matches)  | TODO            |
| **Yes** [Xbox Live Access](#xbox-live-access) + **Yes** [Original Xbox Compatibility](#original-xbox-compatibility) | [Blades](#1-blades)                       | **Primary**         | **Primary**          | [Cipher](#cipher)               | False           | True: [Online-Only Stealth Servers Positive Matches](#online-only-stealth-servers-positive-matches)  | TODO            |
| **Yes** [Xbox Live Access](#xbox-live-access) + **No** [Original Xbox Compatibility](#original-xbox-compatibility)  | [Metro](#metro)                         | **Primary**         | **Primary**          | [Proto](#proto) or [XbGuard](#xbguard) | False           | Maybe: [Online-Only Stealth Servers](#online-only-stealth-servers)                  | TODO            |
| **Yes** [Xbox Live Access](#xbox-live-access) + **No** [Original Xbox Compatibility](#original-xbox-compatibility)  | Aurora                                       | **Primary**         | [Metro](#metro)         | [Proto](#proto) or [XbGuard](#xbguard) | False           | Maybe: [Online-Only Stealth Servers](#online-only-stealth-servers)                  | TODO            |
| **Yes** [Xbox Live Access](#xbox-live-access) + **No** [Original Xbox Compatibility](#original-xbox-compatibility)  | [Kinect / NXE V2](#kinect--nxe-v2)       | **Primary**         | **Primary**          | [Proto](#proto) or [XbGuard](#xbguard) | False           | Maybe: [Online-Only Stealth Servers](#online-only-stealth-servers)                  | TODO            |
| **Yes** [Xbox Live Access](#xbox-live-access) + **No** [Original Xbox Compatibility](#original-xbox-compatibility)  | [New Xbox Experience (NXE) V1](#new-xbox-experience-nxe-v1) | **Primary**         | **Primary**          | [Proto](#proto) or [XbGuard](#xbguard) | False           | Maybe: [Online-Only Stealth Servers](#online-only-stealth-servers)                  | TODO            |
| **Yes** [Xbox Live Access](#xbox-live-access) + **No** [Original Xbox Compatibility](#original-xbox-compatibility)  | [Blades](#1-blades)                       | **Primary**         | **Primary**          | [Proto](#proto) or [XbGuard](#xbguard) | False           | Maybe: [Online-Only Stealth Servers](#online-only-stealth-servers)                  | TODO            |

## 3. Non-Permutations

### Body (1/4)

```
; launch.xex V3.0 config file
; parsed by simpleIni http://code.jellycan.com/simpleini/
; currently supported devices and paths:
; internal hard disk    Hdd:\
; usb memory stick      Usb:\
; memory unit           Mu:\
; USB memory unit       UsbMu:\
; big block NAND mu     FlashMu:\
; internal slim 4G mu	IntMu:\
; internal corona 4g mu MmcMu:\
; CD/DVD                Dvd:\     (not recommended to use this one)
; buttons can point to any xex, or any CON with default.xex in it on any of the above devices
; note that Right Bumper is ALWAYS default to return NXE
; if you want to assign an additional one, use the path Sfc:\dash.xex ie:
; BUT_A = Sfc:\dash.xex


; all comments and fields in this file are optional, you can remove anything you don't need
; sorry for any double negatives :p
; njoy, cOz

; example entry
; Default = Hdd:\FreeStyle\default.xex
[Paths]
BUT_A = 
BUT_B = 
BUT_X = 
BUT_Y = 
Start = 
Back = 
LBump = 
RThumb = 
LThumb = 
```

### `[Paths]`

#### `Start`

### `Default`

### `Power`

### `Configapp`

### Body (2/4)

```
; if set, this will be run as a title before any other option occurs, does not get circumvented by held buttons or default
; guide/power opts are processed after this; intended for a short video player to allow replacing bootanim
Fakeanim = 

; by default this only dumps to UART, setting a file here will cause unhandled exception info to be dumped
; as text to a file. Same path restraints as the quick launch buttons.
; if exchandler is set to false, this option does nothing.
; note that this uses the first drive of the class found, so if you use usb: and have more than one usb device
; it may wind up on any of the usb devices depending on which was enumerated first. The path for the file is only
; checked on boot, so the device must be present at power on and at crash time for this to be effective
; ie: dumpfile = Usb:\crashlog.txt
Dumpfile = 
```

### `[Plugins]`

1. [Xbox 360 Neighborhood (xbdm.xex)](#xbox-360-neighborhood-xbdmxex) or NULL.
2. [LAN Debug Tools](#lan-debug-tools) or NULL.
3. [Stealth Servers](#stealth-servers) given use case:
	-> [Legacy Dashboard Compatibility](#legacy-dashboard-compatibility)
	-> [Original Xbox Compatibility Stealth Servers](#original-xbox-compatibility-stealth-servers)
4. [CoronaKeysFix](#coronakeysfixed) always.
5. [PluginUI](#pluginui) with stable build.

### Body (3/4)

```
; these options are never used directly by dash launch but serve to give the configuration program
; a place to keep these values; note that things like ftp and udp servers are only running while installer is running
[Externals]

; if true, the configuration application will start a FTP server (user/pass: xbox)
; if not present default is FALSE
ftpserv = false

; if ftpserv is true, this is the port that will be used by the FTP server
; if not present default is 21
ftpport = 21

; if true, the configuration application will start the xebuild update server
; if not present default is FALSE
updserv = false

; if true, the configuration application will start in launch mode instead of options mode
; if not present default is FALSE
calaunch = false

; if true, temps in installer and in guide (shuttemps option) will be shown in fahrenheit instead of celsius
; if not present default is FALSE
fahrenheit = false


[Settings]

; if true, brining up miniblade in NXE and then pressing Y will cause launch.xex to relaunch for you
; note you must release Y button then press desired QuickLaunchButtons after or use default item
; if not present default is TRUE
nxemini = true

; if true ping limit will be removed for system link play (thanks FBDev!)
; if not present default is FALSE
pingpatch = true

; if true header license bits will be patched for addon content (00000002 type content)
; if not present default is FALSE
contpatch = true

; if true header license bits will be patched for xbla content (000D0000 type content)
; if not present default is FALSE
xblapatch = true

; usually used in combination with contpatch/xblapatch or when XBLA is run extracted instead of from a container, spoofs replies from XamContentGetLicenseMask
; if not present default is FALSE
licpatch = true

; Normally when a fatal error occurs the xbox will just freeze, setting this to false will cause a reboot or powerdown
; setting to TRUE will also disable the unhandled exception filter which tries to intercept recoverable unhandled exceptions with exit to dash
; if not present default is FALSE
fatalfreeze = false

; when fatalfreeze is set to false, setting this to true will cause the box to reboot, setting it to false will instead have the box shut down
; note that this option does NOTHING when fatalfreeze is set to true
; if not present default is FALSE
fatalreboot = false

; setting this to true will cause the box to reboot (soft reboot) the way it was intended to
; on jtag ONLY set this to true if using blackaddr's reboot fix for SMC, else on reboot you will get E71 and corrupted dash/video/etc settings
; if not present default is TRUE
safereboot = true

; when set to true, it is possible to hold RB when launching a game to have the region that the game gets from xam spoofed
; if not present this is set to FALSE
regionspoof = true

; when regionspoof is true, you set your region here in hex preceding the value with 0x, for example devkit would be region = 0x7fff
; if not present but regionspoof is set to true, this is set to 0x7FFF
region = 0x7fff

; when set to false, ejecting a dvd video or game returns you to your default item, set to true to auto exit to NXE
; if not present this is set to FALSE
dvdexitdash = false

; when set to false, using the exit item in an XBLA game returns you to your default item, set to true to exit to NXE arcade menu
; if not present this is set to FALSE
xblaexitdash = false

; when set to true, using miniblades system setting options will not exit to NXE
; if not present this is set to FALSE
nosysexit = false

; when set to true, miniblades will not appear... ever (requested as child saftey measure)
; note that using this option overrides everything in dash launch that relies on miniblade exits to function
; if not present this is set to FALSE
nohud = false

; when set to false, xbox will be capable of finding system updaters
; if not present this is set to TRUE
noupdater = true

; when set to true,  dash launch will put all debug strings out to uart
; if not present this is set to FALSE
debugout = true
```

### `liveblock`

-> [Block Xbox Live](#block-xbox-live)

### `livestrong`

-> [Block Xbox Live](#block-xbox-live)

### Body (4/4)

```
; when set to TRUE the X (guide) and power button on IR remotes will cause the xbox to boot to NXE instead of default item
; note that powering on with the windows/start button automatically goes to NXE's media center now regardless of how this is set
; if not set this value will be FALSE
remotenxe = false

; when set to TRUE all USB drives will be polled at hddtimer intervals for the file "alive.txt" in their root
; if the file exists, it will be recreated and 16 random bytes written to it on each poll which should keep drives from spinning down
; if not set this value will be FALSE
hddalive = false

; in seconds, the interval between when USB devices will be polled for "alive.txt" file
; if not set and hddalive is set to TRUE this value will be 210
hddtimer = 210

; attempts to disable popups related to signing in, like "live is blocked" and similar
; !! WARNING OTHER THINGS DO USE THIS DIALOG AND DETECTING THAT IT'S A LOGIN DIALOG MAY NOT BE PERFECT !!
; !! to sign into live profiles other than auto signing on boot you MUST accept the 'check live for updates' dialog BEFORE enabling this option !!
; if not set this value will be FALSE
signnotice = true

; when you hold guide button to shut down xbox, normally the 'cancel' option is selected
; setting this to TRUE will cause the shutdown option to be auto selected instead
; !! WARNING OTHER THINGS DO USE THIS DIALOG AND DETECTING THAT IT'S SHUTDOWN DIALOG MAY NOT BE PERFECT !!
; if not set this value will be FALSE
autoshut = false

; when you hold guide button to shut down xbox, normally a dialog comes up
; setting this to TRUE will cause the console to shutdown instead of show a dialog
; !! WARNING OTHER THINGS DO USE THIS DIALOG AND DETECTING THAT IT'S SHUTDOWN DIALOG MAY NOT BE PERFECT !!
; if not set this value will be FALSE
autooff = false

; 14699+ has native http functions, but you are forced to be logged into use them
; this patch removes that restriction, set to false to disable it if you have any problems
; if not set this value will be TRUE
xhttp = false

; when tempbcast is set to TRUE the raw temp data from smc will be broadcast over UDP at temptime second
; intervals on port tempport
; if not set this value will be FALSE
tempbcast = false

; if not set this value will be 10
temptime = 10

; if not set this value will be 7030
tempport = 7030

; when set to TRUE all titles will have the insecure socket privilege
; if not set this value will be FALSE
sockpatch = false

; when set to TRUE dash launch will not erase launchdata before launching a quick launch item
; if not set this value will be FALSE
passlaunch = false

; when set to TRUE various functions will be spoofed to make firmware think it's connected to LIVE
; this does not compensate for the fact that it cannot contact LIVE servers
; setting this to TRUE forces liveblock to TRUE
; if not set this value will be FALSE
fakelive = false

; when set to TRUE network/cloud storage options should not show up in disk dialogs
; if not set this value will be TRUE
nonetstore = false

; when set to TRUE a snapshot of the console temperature data will be displayed in the console shutdown dialog (displayed when guide button is held)
; !! WARNING OTHER THINGS DO USE THIS DIALOG AND DETECTING THAT IT'S SHUTDOWN DIALOG MAY NOT BE PERFECT !!
; enabling this option disables autooff
; if not set this value will be FALSE
shuttemps = false

; when true, any devkit profiles on the console will not appear as corrupt and can be used
; any changes such as saving games or getting achievements will resign the profile with the current/retail keyvault
; this seems not to affect glitch/jtag dev crossflash, but could affect these profiles on true devkits
; if not set this value will be FALSE
devprof = false

; when true, system link data will be encrypted for communication with devkits
; if not set this value will be FALSE
devlink = false

; when true dash launch will perform automatic disk swapping
; WARNING!! do not enable if you use FSD or swap.xex for this !!
; if not set this value will be FALSE
autoswap = true

; when true, disables kinect health pseudo video at game launch
; if not set this value will be TRUE
nohealth = true

; when true, disables dash locale setup screens when settings already exist
; if not set this value will be TRUE
nooobe = true

; when true dash launch will automatically enable fakelive functionality only during official dash and indie play sessions
; if not set this value will be FALSE
autofake = false

; if some titles benefit from fakelive, add them here - only 10 may be listed
autofake0 = 0x00000000
autofake1 = 0x00000000
autofake2 = 0x00000000
autofake3 = 0x00000000
autofake4 = 0x00000000
autofake5 = 0x00000000
autofake6 = 0x00000000
autofake7 = 0x00000000
autofake8 = 0x00000000
autofake9 = 0x00000000

; when true and autofake is enabled, contpatch will be enabled for community games only
; this option will be ignored if autofake is not enabled
; if not set this value will be FALSE
autocont = false
```

## 4. Definitions

### Block Xbox Live

- `liveblock = true`
- `livestrong = true`

### `launch.ini`

> [!FAQ] ABOUT
> - A configuration file (`launch.ini`) which **defines** boot options and behavior:
>	- Default dashboards
>	- Fan Speed
>	- [Plugins](#plugins)
>	- System behavior

> [!TLDR] EDIT INSTRUCTIONS
> -> On console, **open** *Dashlaunch.*
> -> On PC, **open** `launch.ini` within a text editor.

### Legacy Dashboard Compatibility

1. **To enable,** the following conditions must be **true:**
	-> Use a [stealth server](#stealth-servers).

### Primary Dashboard

> [!FAQ] ABOUT
> 1. Set One (1) Dashboard -> `Default = Path\To\File.xex`
> 2. Set Two (2) Dashboards:
>	-> Primary Dashboard
>		1. `Guide = Path\To\File.xex`
>		2. `Power = Path\To\File.xex`
>		3. `Start = Path\To\File.xex`
>	-> Secondary Dashboard: `Default = Path\To\File.xex`

### Official Dashboard Revisions

> [!INFO] LINKS
> - [Xbox 360 Dashboard | Xbox Wiki | Fandom](https://xbox.fandom.com/wiki/Xbox_360_Dashboard), [Internet Archive](https://web.archive.org/web/20250824030722/https://xbox.fandom.com/wiki/Xbox_360_Dashboard)

#### Blades

> [!FAQ] ABOUT
> - Builds 1888 -> 6717
> - November 2005 -> November 2008

#### New Xbox Experience (NXE) V1

> [!FAQ] ABOUT
> - Builds ~6717 -> ~9199
> - November 2008 -> April 2010

#### Kinect / NXE V2

> [!FAQ] ABOUT
> - Builds ~9199 -> ~12611
> - April 2010 -> November 2010

#### Metro

> [!FAQ] ABOUT
> - Builds 12611 -> 17559 (Latest)
> - November 2010 -> Present

### Online-Only Stealth Servers

### Optimal Plugin Order

#### 1. [LAN Servers](#lan-servers)

#### 2. [LAN Debug Tools](#lan-debug-tools)

#### 3. [Stealth Servers](#stealth-servers)

#### 4. [Patches](#patches)

#### 5. [PluginUI](#pluginui)

### Original Xbox Compatibility

The following conditions must be **true:**

#### Original Xbox Compatibility: Files Installed.

#### Original Xbox Compatibility: Stealth Servers:

- a compatible **stealth server** must be set and running.
	- **Cipher:** requires Internet availability.
- a non-compatible **stealth server** must be avoided:
	- anything **not Cipher;** Proto, XbGuard, etc.

#### Online-Only Stealth Servers: Positive Matches

- Cipher
- XbGuard

#### Online-Only Stealth Servers: Negative Matches

- Proto

#### Blades

> [!FAQ] ABOUT
> - Builds 1888 -> 6717
> - November 2005 -> November 2008

#### New Xbox Experience (NXE) V1

> [!FAQ] ABOUT
> - Builds ~6717 -> ~9199
> - November 2008 -> April 2010

#### Kinect / NXE V2

> [!FAQ] ABOUT
> - Builds ~9199 -> ~12611
> - April 2010 -> November 2010

#### Metro

> [!FAQ] ABOUT
> - Builds 12611 -> 17559 (Latest)
> - November 2010 -> Present

### File Paths

#### Root

```
; internal hard disk    Hdd:\
; usb memory stick      Usb:\
; memory unit           Mu:\
; USB memory unit       UsbMu:\
; big block NAND mu     FlashMu:\
; internal slim 4G mu	IntMu:\
; internal corona 4g mu MmcMu:\
```

#### Dashboards: `dashboards\`

#### Plugins: `plugins\`

##### LAN Debug Tools: `plugins\debug\`

##### LAN Servers: `plugins\servers\`

##### Patches: `plugins\patches\`

##### Stealth Servers: `plugins\online\`

##### PluginUI: `plugins\ui\`

### Plugins

> [!INFO] LINKS
> - [launch.ini](#launchini)

#### Developer Tools

##### HvP2.xex

> [!CITE] [HvP2.xex - ConsoleMods Wiki](https://consolemods.org/wiki/File:HvP2.xex), [Internet Archive](https://web.archive.org/web/20250810155854/https://consolemods.org/wiki/File:HvP2.xex)
> An Xbox 360 plugin by <u>Xx jAmes t xX</u> and <u>Chr0m3 x MoDz</u> that enables use of *development* builds on a RGH/JTAG.

#### LAN Servers

##### FTPdll.xex

> [!INFO] LINKS
> - [FTPdll 0.3.zip](https://consolemods.org/wiki/images/2/25/Ftpdll_0.3.zip), [Internet Archive](https://web.archive.org/web/20250902210221/https://consolemods.org/wiki/images/2/25/Ftpdll_0.3.zip)

##### Xbox 360 Neighborhood (xbdm.xex)

#### LAN Debug Tools

> [!faq] ABOUT
> - Tools which facilitate *debugging* and/or *cheat engines* for supported games, over a LAN.
> 	- *JRPC*
> 	- *JRPC2*
> 	- *XDRPC*
> 	- *XRPC*
> - Used in conjunction with [Xbox 360 Neighborhood (xbdm.xex)](#xbox-360-neighborhood-xbdmxex).

> [!info] LINKS
> - [Beginners Guide To XRPC and JRPC(2)](https://www.thetechgame.com/Archives/t=6912664/beginners-guide-to-xrpc-and-jrpc-2.html), [Internet Archive](https://web.archive.org/web/20251215173001/https://www.thetechgame.com/Archives/t=6912664/beginners-guide-to-xrpc-and-jrpc-2.html)
> - [XCE Tool - ConsoleMods Wiki](https://consolemods.org/wiki/Xbox_360:XCE_Tool), [Internet Archive](https://web.archive.org/web/20250916071914/https://consolemods.org/wiki/Xbox_360:XCE_Tool)

#### Patches

##### AuroraCrashPatcher

> [!faq] ABOUT
> - A tool designed to *prevent* crashes in custom dashboards during the download of many assets, such as game box art.

> [!info] LINKS
> - [GitHub - Ste1io/AuroraCrashPatcher: Quick patch to prevent fatal crashing when downloading title assets (boxart, etc) through FSD or Aurora.](https://github.com/Ste1io/AuroraCrashPatcher), [Internet Archive](https://web.archive.org/web/20250219062541/https://github.com/Ste1io/AuroraCrashPatcher)

##### Cheats

> [!FAQ] ABOUT
> - Methods which *alter* game play, *in less than intended or unintended ways.*
> - *Unlock* levels, characters, story progress, etc. with less effort.

##### CoronaKeysFix

> [!CITE] [GitHub - InvoxiPlayGames/CoronaKeysFixPlugin](https://github.com/InvoxiPlayGames/CoronaKeysFixPlugin), [Internet Archive](https://web.archive.org/web/20250919020528/https://github.com/InvoxiPlayGames/CoronaKeysFixPlugin)
> An Xbox 360 DashLaunch plugin to fix the issues in *Rock Band* and *Dance Central* games on Corona motherboards.

> [!INFO] LINKS
> - [Motherboard Information - ConsoleMods Wiki](https://consolemods.org/wiki/Xbox_360:Motherboard_Information#Corona), [InternetArchive](https://consolemods.org/wiki/Xbox_360:Motherboard_Information)

##### Xbox Live Gold Spoofing

> [!FAQ] FEATURES
> - *Enables* free online multiplayer for a *limited* selection of games.
> - Alternatives:
> 	- [Stealth Network (SNet)](#stealth-network-snet)
> 	- [XLink Kai](#xlink-kai)

> [!INFO] LINKS
> - [GitHub - Gualdimar/GoldSpoof17559: JRPC tool and dashlaunch plugin for spoofing gold on 17559 dash](https://github.com/Gualdimar/GoldSpoof17559), [Internet Archive](https://web.archive.org/web/20250731075702/https://github.com/Gualdimar/GoldSpoof17559)

##### Halo Sunrise

> [!FAQ] FEATURES
> - *Restores* online matchmaking for *Halo* series' games:
> 	- *Halo 3*
> 	- *Halo: Reach*

> [!INFO] LINKS
> - [GitHub - Byrom90/Halo_Sunrise_Plugin_2.0:](https://github.com/Byrom90/Halo_Sunrise_Plugin_2.0), [Internet Archive](https://web.archive.org/web/20250914113624/https://github.com/Byrom90/Halo_Sunrise_Plugin_2.0)

##### UsbdSecPatch

> [!FAQ] FEATURES
> - Patch to *allow* unsigned USB execution.
> - Supports *XInput* controllers and game pads.

> [!INFO] LINKS
> - [GitHub - InvoxiPlayGames/UsbdSecPatch](https://github.com/InvoxiPlayGames/UsbdSecPatch) , [Internet Archive](https://web.archive.org/web/20250925080252/https://github.com/InvoxiPlayGames/UsbdSecPatch)

#### PluginUI

> [!FAQ] FEATURES
> - *Custom* Guide Menu / Heads Up Display (HUD)
> - *Extensible* with theme support.
> 	- *Reproduction* of the [NXE](#new-xbox-experience-nxe-v1) HUD.
> 	- *Beta version* of the NXE HUD.

> [!INFO] LINKS
> - [Discord](https://discord.gg/mnq9dbR6mN)

#### Stealth Network (SNet)

> [!FAQ] FEATURES
> - *Custom* matchmaking handler.
> - *Does not require* clients or users to have *Xbox Live Gold.*
> - *Play online* by connecting to match hosts (who have *Xbox Live Gold*).
> - *Supports all* online multiplayer games.

> [!INFO] LINKS
> - [Release - SNET Now available To Most Stealth Servers | Se7enSins Gaming Community](https://www.se7ensins.com/forums/threads/snet-now-available-to-most-stealth-servers-now-working-for-gta-online-1-27-latest-halo.1885487/), [Internet Archive](https://web.archive.org/web/20250704234149/https://www.se7ensins.com/forums/threads/snet-now-available-to-most-stealth-servers-now-working-for-gta-online-1-27-latest-halo.1885487/)

#### Stealth Servers

> [!FAQ] FEATURES
> Services which *obfuscate* a console's modded state, use of homebrew, and play of unreleased games, from *Xbox Live's* detection methods.

> [!WARNING] WARNING
> Failure to use or of a Stealth Server WILL RESULT in *Xbox Live* services BLACKLISTING your console's KV.

| Stealth Server | Free/Paid Subscription                            | Supports Backwards Compatibility | Supports Cheats | Supports Retail Dashboards          | Supports Custom HUD                                                   |
| -------------- | ------------------------------------------------- | -------------------------------- | --------------- | ----------------------------------- | --------------------------------------------------------------------- |
| [Cipher](#cipher)    | Free with paid periodic or lifetime subscription. | Yes                              | Yes             | Build 9199 and earlier have issues. | Yes, configurable.                                                    |
| [Proto](#proto)     | Free.                                             | No                               | No              | Yes                                 | Yes, configurable via `proto.ini`.                                    |
| [XbGuard](#xbguard)   | Free with paid periodic or lifetime subscription. | No                               | Yes             | Yes                                 | Yes, configurable.                                                    |

> [!WARNING] ONLINE CHEATS WARNING
> DO NOT CHEAT in online multiplayer.

##### Cipher

> [!FAQ] FEATURES
> - *Paid,* with periodic and lifetime subscriptions.
> - Custom matchmaking support, known as [Stealth Network (SNet)](#stealth-network-snet).
> - *Customizable* user-interface.
> - Load plugins as *modules.*

> [!INFO] LINKS
> - [Cipher - The Leading Stealth Solution](https://cipher.services/), [Internet Archive](https://web.archive.org/web/20250919130058/https://cipher.services/)
> - [Features – Cipher](https://cipher.services/en/features), [Internet Archive](https://web.archive.org/web/20250831201037/https://cipher.services/en/features)
> - [Support – Cipher](https://cipher.services/en/support), [Internet Archive](https://web.archive.org/web/20250825001153/https://cipher.services/en/support)
> - [Discord](https://cipher.services/en/discord)

##### Proto

> [!FAQ] FEATURES
> - Free
> - Offline
> - Minimalist
> - No Cheats

> [!INFO] LINKS
> - [Proto Stealth](https://freestealth.com/) , [Internet Archive](https://web.archive.org/web/20250917194014/http://www.freestealth.com/)

##### XbGuard

> [!FAQ] FEATURES
> - *Paid,* with periodic and lifetime subscriptions.
> - Custom matchmaking support, known as [Stealth Network (SNet)](#stealth-network-snet).
> - *Customizable* user-interface.
> - Load plugins as *modules.*

> [!INFO] LINKS
> - [xbGuard | The Supreme Stealth Service](https://xbguard.live/) , [Internet Archive](https://web.archive.org/web/20250913174402/https://xbguard.live/)
> - [Discord](https://discord.com/invite/YkpmBHK)

### Xbox Live Access

1. **To enable,** the following conditions must be **true:**
	1. [Block Xbox Live](#block-xbox-live) must be **unset.**
	2. [Stealth Servers](#stealth-servers) must be **set.**
2. **To disable,** the following conditions must be **false:**
	1. [Block Xbox Live](#block-xbox-live) must be **set.**
	2. [Stealth Servers](#stealth-servers) <u>may</u> be **unset.**

## 5. Backlog

- [ ] Define permutations
- [ ] Define `.ini` command lines for permutations.
- [ ] Specify file paths for dashboards and plugins:
	- [ ] Remove versioning and include a VERSION file.
- [ ] Define recommendations
	- [ ] Avoid using [Xbox 360 Neighborhood (xbdm.xex)](#xbox-360-neighborhood-xbdmxex), to secure system, and not cheat.
	- [ ] Disable FTP after initialization, to secure system.
	- [ ] Do not cheat in online multiplayer.
	- [ ] Use Aurora for offline use, homebrew, fastest presentation.
	- [ ] Use Cipher or no stealth for original Xbox compatibility.
	- [ ] Use PluginUI for classic theming.
	- [ ] Use NXE for most legacy theme, with support for GOD.
- [ ] Create `launch.ini` permutations, fifteen (15) total.
	- [ ] Place into archive files:
		- [ ] Include README: `launch-ini-README.md`
			- [ ] Explain use case.
			- [ ] Include a copy of this document.
		- [ ] Default file name: `launch.ini`
- [ ] Create a Aurora script to unpack known good archives.
	- [ ] Support `launch.ini` permutations.
	- [ ] Check for expected required files (dashboards, plugins, etc.).
		- [ ] Unpack expected required files.
	- [ ] Make logo.
	- [ ] Make git repo, include script and permutations, with files.
	- [ ] Pseudo code:
		- [ ] Validate files (archives, paths)
		- [ ] Backup existing `launch.ini`
		- [ ] Restore backup on failure
		- [ ] Warn user on failure
		- [ ] Prompt user to reboot on success
		- [ ] Text parse; edit lines instead of copy/paste files
			- [ ] If line found, edit.
			- [ ] If line not found, append at top or bottom, with comments?
		- [ ] Descriptive options
- [ ] After completion, transform backlog into changelog. Have no backlog remain.