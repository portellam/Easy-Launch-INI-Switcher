# To Do

## Goals
- Switch between various `launch.ini` configurations.
- Least user input.

## Backlog
- [x] CONTRIBUTION
- [x] CONTRIBUTORS

- [ ] README
  - [x] Usage
  - [x] Why?
  - [ ] Changelog
  - [x] Download
  - [x] Contact
  - [x] Contributors
  - [x] License
  - [x] Citations
    - [x] Aurora
    - [x] backwards compatibility
    - [x] consolemods.org
    - [x] launch.ini
    - [x] official dashboard history
    - [x] stealth servers
    - [x] Xbox 360 mods

- [ ] script
  - [ ] Do one (1) of the following, validate for `.xex` paths:
    - [ ] Do the heavy lifting; search for common and specific paths.
    - [ ] Specify in `.ini`; parse config file for exact paths, defined by user.
    - [ ] Parse for matches, and save paths to `.ini`.
  - [ ] Only generate a launch.ini for the following:
    - [ ] dashboards
    - [ ] stealth servers
    - [ ] Use master `launch.ini` for other plugins and settings.
  - [ ] Filters to set what options to use.
    - [ ] Allow for overrides.
    - [ ] Returns list of valid choices.
    - [ ] Conflicts will remove a choice from the list.
  - [ ] Name, description
  - [ ] Backup existing `launch.ini`.
  - [ ] Determine method of tracking information.
    - [ ] Database of expected paths and executables.
    - [ ] Pre configured `launch.ini`. Use as reference copy.
      - [ ] Think of `generate-evdev`, where the file is changed at the matching lines. 
  - [ ] Manage configurations.
  - [ ] Safe failures; if operation fails, undo changes.
  - [ ] Validation

- [x] sponsorship

## Changelog
- Initalized repository.

## Notes

- [logo](https://pixabay.com/vectors/floppy-disk-disc-data-pc-1292821/), https://pixabay.com/users/openclipart-vectors-30363/


### Configurations
- Boot Dashboards
  -> Latest Microsoft Dashboard
  -> Legacy Microsoft Dashboard
  -> Custom Dashboard
- Original Xbox Compatibility (Backwards Compatibility)
  -> Supported
  -> Unsupported
- Stealth Servers
  -> Backwards Compatibility Support
  -> Legacy Microsoft Dashboard Support
  -> Offline Support
- Xbox Live
  -> Enabled
  -> Disabled

### Major Permutations
1. Backwards Compatibility (Enabled) + Xbox Live (Enabled)
2. Backwards Compatibility (Enabled) + Xbox Live (Disabled)
3. Backwards Compatibility (Disabled) + Xbox Live (Enabled)

### Minor Permutations
1. Lorem ipsum