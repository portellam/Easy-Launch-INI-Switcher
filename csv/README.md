# Databases
The purposes of the database files:
- to be parseable by the software.
- flexibility: to define reproduceable `launch.ini` permutations, regardless of homebrew paths.
- to allow contributor(s) to audit, append to, or subtract as need (homebrew conflicts, new releases).

## Disclaimer
The database files have NOT been peer reviewed. However, the permutations should work as intended.

Unauthorized modifications to database files may lead to UNEXPECTED BEHAVIOR. Please use caution when making changes.

## Files

| Database                       | Usage                                                             |
| ------------------------------ | ----------------------------------------------------------------- |
| [dashboard-paths.csv][01]      | Dashboard directories and `.xex` files.                           |
| [dashboards.csv][02]           | Dashboard revisions and types.                                    |
| [directory-paths.csv][03]      | Root directories.                                                 |
| [mount-paths.csv][04]          | Available drive mounts.                                           |
| [permutations.csv][05]         | Possible permutations of `launch.ini`.                            |
| [plugin-paths.csv][06]         | Plugin directories and types.                                     |
| [plugins.csv][07]              | Plugin indices and amounts.                                       |
| [stealth-server-paths.csv][08] | Stealth server directories and `.xex` files.                      |
| [stealth-servers.csv][09]      | Stealth server availabilities, compatibilities, and requirements. |

[01]: dashboard-paths.csv
[02]: dashboards.csv
[03]: directory-paths.csv
[04]: mount-paths.csv
[05]: permutations.csv
[06]: plugin-paths.csv
[07]: plugins.csv
[08]: stealth-server-paths.csv
[09]: stealth-servers.csv

#### Click [here](#databases) to return to the top of this document.