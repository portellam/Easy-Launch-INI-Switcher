--[[
This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.

Filename:       Main.lua
Description:    Switch between multiple launch.ini configurations, as defined by
                .csv databases.
Author(s):      Alex Portell <github.com/portellam>
Maintainer(s):  Alex Portell <github.com/portellam>
License:        GNU General Public License v3.0
Version:        1.0
]]  

--[[ parameters ]]
  scriptTitle = "Easy Launch.ini Switcher"
  scriptAuthor = "Alex Portell"
  scriptVersion = 1
  scriptDescription = "Switch between multiple launch.ini configurations, as defined by .csv databases. github.com/portellam"
  scriptIcon = "logo.png"
  scriptPermissions = { "filesystem" }

  require("MenuSystem");

  local ProgressCount = 0
  local ProgressMax = 100
  local ProgressDiff = ProgressMax

  local CSV = {
    dashboards        = "csv/dashboards.csv",
    dashboard_paths   = "csv/dashboard-paths.csv",
    directory_paths   = "csv/directory-paths.csv",
    mount_paths       = "csv/mount-paths.csv",
    permutations      = "csv/permutations.csv",
    plugin_paths      = "csv/plugin-paths.csv",
    plugins           = "csv/plugins.csv",
    stealth_paths     = "csv/stealth-server-paths.csv",
    stealth_servers   = "csv/stealth-servers.csv",
    executables       = "csv/executables.csv",
  }

  local launch_ini_path = nil
  local launch_ini_backup_path = nil

  local db = {}
  local perms = {}

--[[ main ]]
  function main()
    print("-- " .. scriptTitle .. " Started...");

    if init() == false then
      goto scriptend;
    end

    MakeMainMenu();
    DoShowMenu();
      
    ::scriptend::
  end

--[[ basic helpers ]]
  local function trim(s)
    if not s then return "" end
    return s:match("^%s*(.-)%s*$") or ""
  end

  local function split(line, sep)
    if not line then return {} end
    sep = sep or ","
    local out = {}
    for field in line:gmatch("([^" .. sep .. "]+)") do
      out[#out + 1] = trim(field)
    end
    return out
  end

  local function read_lines(path)
    local f = io.open(path, "r")
    if not f then return {} end
    local t = {}
    for l in f:lines() do
      t[#t + 1] = l
    end
    f:close()
    return t
  end

  local function read_csv(path)
    local lines = read_lines(path)
    if #lines == 0 then
      return { header = {}, rows = {} }
    end

    local header = split(lines[1])
    local rows = {}

    for i = 2, #lines do
      local cols = split(lines[i])
      local row = {}
      for c = 1, #header do
        row[header[c]] = cols[c] or ""
      end
      rows[#rows + 1] = row
    end

    return { header = header, rows = rows }
  end

  local function to_bool(v)
    if not v then return false end
    v = v:lower()
    return v == "1" or v == "true" or v == "yes" or v == "y"
  end

--[[ launch.ini location detection ]]
  local function detect_launch_ini_location()
    -- List of known Xbox 360 mount points (exact format required by FileSystem)
    local known_mounts = { "Mu:\\", "Usb:\\", "UsbMu:\\", "Hdd:\\", "IntMu:\\", "MmcMu:\\", "FlashMu:\\" }

    -- Priority search - these are most common locations
    for _, mount in ipairs(known_mounts) do
      local candidate = mount .. "launch.ini"
      if FileSystem.FileExists(candidate) then
        local backup_path = mount .. "launch.ini.old"
        return candidate, backup_path
      end
    end

    -- Fallback: read from CSV and try all defined mount paths
    local csv = read_csv(CSV.mount_paths)
    for _, row in ipairs(csv.rows) do
      if row.Path then
        local mount = row.Path
        -- Ensure it ends with \
        if mount:sub(-1) ~= "\\" then
          mount = mount .. "\\"
        end
        local candidate = mount .. "launch.ini"
        if FileSystem.FileExists(candidate) then
          local backup_path = mount .. "launch.ini.old"
          return candidate, backup_path
        end
      end
    end

    return nil
  end

--[[ loaders with error checking ]]
  local function load_dashboards()
    local csv = read_csv(CSV.dashboards)
    local out = {}
    for _, r in ipairs(csv.rows) do
      if r.Name ~= "" then
        out[#out + 1] = {
          id = r.Name,
          official = to_bool(r.Official),
          legacy = to_bool(r.Legacy),
          min_version = r["Version: Minimum"] or "",
        }
      end
    end
    return out
  end

  local function load_directory_paths()
    local csv = read_csv(CSV.directory_paths)
    local out = {}
    for _, r in ipairs(csv.rows) do
      if r.Keyword and r.Path then
        out[r.Keyword] = r.Path
      end
    end
    return out
  end

  local function load_mount_paths()
    local csv = read_csv(CSV.mount_paths)
    local out = {}
    for _, r in ipairs(csv.rows) do
      if r.Label and r.Path then
        out[r.Label] = r.Path
      end
    end
    return out
  end

  local function load_dashboard_paths()
    local csv = read_csv(CSV.dashboard_paths)
    local out = {}
    for _, r in ipairs(csv.rows) do
      if r.Name then
        out[r.Name] = { path = r.Path or "", exe = r.Executable or "" }
      end
    end
    return out
  end

  local function load_executables()
    local csv = read_csv(CSV.executables)
    local out = {}
    for _, r in ipairs(csv.rows) do
      if r.Executable ~= "" then out[#out + 1] = r.Executable end
    end
    return out
  end

  local function load_plugins()
    local csv = read_csv(CSV.plugins)
    local out = {}
    for _, r in ipairs(csv.rows) do
      out[#out + 1] = { index = tonumber(r.Index), id = r.Name, max = tonumber(r["Count: Maximum"]) }
    end
    return out
  end

  local function load_plugin_paths()
    local csv = read_csv(CSV.plugin_paths)
    local out = {}
    for _, r in ipairs(csv.rows) do
      if r.Name and r.Keyword then
        out[r.Name] = out[r.Name] or {}
        table.insert(out[r.Name], r.Keyword)
      end
    end
    return out
  end

  local function load_stealth_servers()
    local csv = read_csv(CSV.stealth_servers)
    local out = {}
    for _, r in ipairs(csv.rows) do
      out[r.Name] = r
    end
    return out
  end

  local function load_stealth_paths()
    local csv = read_csv(CSV.stealth_paths)
    local out = {}
    for _, r in ipairs(csv.rows) do
      out[r.Name] = out[r.Name] or {}
      table.insert(out[r.Name], { path = r.Path or "", exe = r.Executable or "" })
    end
    return out
  end

  local function load_rules()
    return read_csv(CSV.permutations).rows
  end

  local function build_permutations(db)
    local out = {}
    for i, rule in ipairs(db.rules) do
      local primary = rule["Dashboard: Primary"] or ""
      local secondary = rule["Dashboard: Secondary"] or ""
      local config = rule["Dashboard: ConfigApp"] or ""
      local use_stealth = to_bool(rule["Plugin: Use Stealth Server"])
      local block_live = to_bool(rule["Xbox Live: Is Blocked"])

      local stealth = nil
      if use_stealth then
        -- Simple: pick first available stealth server
        for name, _ in pairs(db.stealth_servers) do
          stealth = { id = name }
          break
        end
      else
        stealth = { id = "NULL" }
      end

      local name = primary
      if secondary ~= "" then name = name .. " → " .. secondary end
      if use_stealth and stealth.id ~= "NULL" then name = name .. " + " .. stealth.id end
      if block_live then name = name .. " (Live Blocked)" end

      out[#out + 1] = {
        id = i,
        name = name,
        primary = { id = primary },
        secondary = secondary ~= "" and { id = secondary } or nil,
        config = config ~= "" and { id = config } or nil,
        stealth = stealth,
        block_live = block_live,
        root = "Hdd:\\"  -- adjust if multi-root support needed
      }
    end
    return out
  end

--[[ lookup helpers ]]
  local function join_paths(base, rel)
    if not rel or rel == "" then return base or "" end
    if not base or base == "" then return rel end
    if base:sub(-1) == "\\" then
      return base .. rel
    end
    return base .. "\\" .. rel
  end

  local function resolve_dashboard_target(d, dashboard_paths, dir_paths, root, executables)
    local info = dashboard_paths[d.id]
    if info then
      local full_path = join_paths(root, info.path)
      if info.exe ~= "" then
        return join_paths(full_path, info.exe)
      elseif info.path ~= "" then
        return join_paths(full_path, executables[1] or "dash.xex")
      end
    end

    local kw_path = dir_paths[d.id] or dir_paths["Dashboard"] or ""
    if kw_path ~= "" then
      return join_paths(root, join_paths(kw_path, executables[1] or "dash.xex"))
    end

    return join_paths(root, executables[1] or "dash.xex")
  end

  local function resolve_stealth_plugin(stealth, stealth_paths, root)
    if not stealth or stealth.id == "NULL" then
      return ""
    end

    local entries = stealth_paths[stealth.id]
    if not entries or #entries == 0 then
      return ""
    end

    local e = entries[1]
    local full_rel = join_paths(e.path, e.exe)
    return join_paths(root, full_rel)
  end

  local function resolve_plugin_keywords(plugin_id, plugin_paths)
    return plugin_paths[plugin_id] or {}
  end

  local function resolve_plugin_path_from_keywords(keywords, dir_paths, root)
    for _, kw in ipairs(keywords) do
      local rel = dir_paths[kw]
      if rel and rel ~= "" then
        return join_paths(root, rel)
      end
    end
    return ""
  end

  -- Improved plugin assignment: respect Index order, then place stealth if used
  local function select_plugins_for_permutation(plugins, plugin_paths, dir_paths, root, stealth)
    local slots = { "", "", "", "", "" }  -- plugin1 to plugin5
    local used = {}
    local stealth_path = ""

    if stealth and stealth.id ~= "NULL" then
      stealth_path = resolve_stealth_plugin(stealth, db.stealth_paths, root)
    end

    -- First pass: place non-stealth plugins by Index order
    for _, p in ipairs(plugins) do
      if p.id == stealth.id then goto continue end  -- skip stealth plugin itself if listed

      local keywords = resolve_plugin_keywords(p.id, plugin_paths)
      local path = resolve_plugin_path_from_keywords(keywords, dir_paths, root)
      if path ~= "" and not used[path] then
        local slot_index = p.index + 1  -- Index 0 → plugin1 (slot 1), Index 4 → plugin5 (slot 5)
        if slot_index >= 1 and slot_index <= 5 and slots[slot_index] == "" then
          slots[slot_index] = path
          used[path] = true
        end
      end

      ::continue::
    end

    -- Second pass: fill remaining slots with any plugins that didn't get their exact index slot
    for _, p in ipairs(plugins) do
      if p.id == stealth.id then goto continue2 end

      local keywords = resolve_plugin_keywords(p.id, plugin_paths)
      local path = resolve_plugin_path_from_keywords(keywords, dir_paths, root)
      if path ~= "" and not used[path] then
        for i = 1, 5 do
          if slots[i] == "" then
            slots[i] = path
            used[path] = true
            break
          end
        end
      end

      ::continue2::
    end

    -- Finally: place stealth if present and a free slot exists
    if stealth_path ~= "" and not used[stealth_path] then
      for i = 1, 5 do
        if slots[i] == "" then
          slots[i] = stealth_path
          used[stealth_path] = true
          break
        end
      end
    end

    return slots
  end

--[[ launch.ini generation ]]
  local function build_launch_ini(permutation, db)
    local root = permutation.root
    local executables = db.executables or {"dash.xex"}

    local primary_path   = resolve_dashboard_target(permutation.primary,   db.dashboard_paths, db.directory_paths, root, executables)
    local secondary_path = resolve_dashboard_target(permutation.secondary, db.dashboard_paths, db.directory_paths, root, executables)
    local config_path    = resolve_dashboard_target(permutation.config,    db.dashboard_paths, db.directory_paths, root, executables)

    local plugin_slots = select_plugins_for_permutation(
      db.plugins,
      db.plugin_paths,
      db.directory_paths,
      root,
      permutation.stealth
    )

    local lines = {}

    lines[#lines + 1] = "[Paths]"

    if secondary_path ~= "" and secondary_path ~= primary_path then
      lines[#lines + 1] = "Default = " .. secondary_path
    end

    if primary_path ~= "" then
      lines[#lines + 1] = "Power = " .. primary_path
    end

    if config_path ~= "" and config_path ~= primary_path and config_path ~= secondary_path then
      lines[#lines + 1] = "configapp = " .. config_path
    end

    lines[#lines + 1] = ""

    lines[#lines + 1] = "[Plugins]"
    local has_plugins = false
    for i = 1, 5 do
      if plugin_slots[i] ~= "" then
        lines[#lines + 1] = "plugin" .. i .. " = " .. plugin_slots[i]
        has_plugins = true
      end
    end
    
    if not has_plugins then
      table.remove(lines, #lines - 1)  -- remove the blank line before [Plugins]
      table.remove(lines, #lines)      -- remove "[Plugins]"
    end

    lines[#lines + 1] = "[Settings]"
    lines[#lines + 1] = "liveblock = " .. (permutation.block_live and "true" or "false")
    lines[#lines + 1] = "livestrong = " .. (permutation.block_live and "true" or "false")
    lines[#lines + 1] = "pingpatch = true"
    lines[#lines + 1] = "xhttp = true"

    return table.concat(lines, "\r\n")
  end

--[[ MenuSystem integration ]]
  local function write_file(path, data)
    local f = io.open(path, "wb")
    if not f then return false end
    f:write(data)
    f:close()
    return true
  end

  local function switch_profile(p, db)
    local ini = build_launch_ini(p, db)
    local ok = write_file(launch_ini_path, ini)

    if ok then
      Script.ShowMessageBox("Success", "launch.ini updated to: " .. p.name .. "\n\nReboot required for changes to take effect.", "OK")
      Script.ShowNotification("launch.ini updated to " .. p.name)
    else
      Script.ShowMessageBox("Error", "Failed to write launch.ini at:\n" .. launch_ini_path, "OK")
    end
  end

  local function find_perm_by_id(id)
    for _, p in ipairs(perms) do
      if p.id == id then return p end
    end
    return nil
  end

--[[ Script helpers ]]
  local function increment_progress()
    ProgressCount = ProgressCount + ProgressDiff
    if ProgressCount > 100 then ProgressCount = 100 end
    Script.SetProgress(ProgressCount);
  end

  local function set_progress_increment(steps)
    if steps < 1 then steps = 1 end
    ProgressDiff = ProgressMax / steps
    ProgressCount = 0
    Script.SetProgress(0)
  end

  local function backup_launch_ini()
    -- launch_ini_backup_path is now same directory + launch.ini.old
    if FileSystem.FileExists(launch_ini_path) then
      -- Overwrite existing .old backup
      if FileSystem.FileExists(launch_ini_backup_path) then
        FileSystem.DeleteFile(launch_ini_backup_path)
      end
      FileSystem.CopyFile(launch_ini_path, launch_ini_backup_path, false)
    end
    return true
  end

  function init()
    set_progress_increment(10)

    Script.ShowMessageBox("Alert", "Detecting launch.ini location...", "OK")
    launch_ini_path, launch_ini_backup_path = detect_launch_ini_location()

    Script.ShowMessageBox("Test", "Direct check: Exists? " .. tostring(FileSystem.FileExists("Hdd:\\launch.ini")) .. "\nDetected path: " .. (launch_ini_path or "nil"), "OK")

    if not launch_ini_path then
      Script.ShowMessageBox("ERROR", "launch.ini not found on any mounted drive.\n\nPlace a valid launch.ini on a drive and retry.", "OK")
      return false
    end
    increment_progress()

    Script.ShowMessageBox("Alert", "Backing up launch.ini...", "OK")
    if not backup_launch_ini() then return false end
    increment_progress()

    Script.ShowMessageBox("Alert", "Parsing directories & mounts...", "OK")
    db.directory_paths = load_directory_paths()
    db.mount_paths = load_mount_paths()
    increment_progress()

    Script.ShowMessageBox("Alert", "Parsing dashboards...", "OK")
    db.dashboards = load_dashboards()
    db.dashboard_paths = load_dashboard_paths()
    if not db.dashboards or #db.dashboards == 0 then
      Script.ShowMessageBox("Error", "Failed to load or empty dashboards.csv", "OK")
      return false
    end
    increment_progress()

    Script.ShowMessageBox("Alert", "Parsing executables...", "OK")
    db.executables = load_executables()
    increment_progress()

    Script.ShowMessageBox("Alert", "Parsing plugins...", "OK")
    db.plugins = load_plugins()
    db.plugin_paths = load_plugin_paths()
    if not db.plugins then
      Script.ShowMessageBox("Error", "Failed to load plugins.csv", "OK")
      return false
    end
    increment_progress()

    Script.ShowMessageBox("Alert", "Parsing stealth servers...", "OK")
    db.stealth_servers = load_stealth_servers()
    db.stealth_paths = load_stealth_paths() or {}
    increment_progress()

    Script.ShowMessageBox("Alert", "Parsing rules...", "OK")
    db.rules = load_rules()
    if not db.rules or #db.rules == 0 then
      Script.ShowMessageBox("Error", "Failed to load permutations.csv or no rules defined", "OK")
      return false
    end
    increment_progress()

    Script.ShowMessageBox("Alert", "Building permutations...", "OK")
    perms = build_permutations(db)
    increment_progress()

    if #perms == 0 then
      Script.ShowMessageBox("Error", "No valid profiles generated. Check permutations.csv rules.", "OK")
      return false
    end

    Script.SetProgress(100)
    return true
  end

  function MakeMainMenu()
    Menu.SetTitle(scriptTitle)
    Menu.SetGoBackText("Cancel")

    Menu.AddMainMenuItem(Menu.MakeMenuItem("<Reset to Original>", "RESET"))

    for _, p in ipairs(perms) do
      Menu.AddMainMenuItem(Menu.MakeMenuItem(p.name, p.id))
    end
  end

  function DoShowMenu()
    local ret, menu, canceled, menuItem = Menu.ShowMainMenu()
    
    if canceled or ret == nil then
      return
    end

    Script.ShowMessageBox("Alert", "Processing selection...", "OK")
    Script.SetProgress(25)

    if ret == "RESET" then
      Script.ShowMessageBox("Alert", "Restoring original launch.ini...", "OK")
      Script.SetProgress(50)
      if FileSystem.FileExists(launch_ini_backup_path) then
        FileSystem.CopyFile(launch_ini_backup_path, launch_ini_path, true)
        Script.ShowMessageBox("Success", "launch.ini restored to original backup.\n\nReboot required for changes.", "OK")
        Script.ShowNotification("launch.ini restored")
      else
        Script.ShowMessageBox("Error", "No backup found to restore", "OK")
      end
    else
      Script.ShowMessageBox("Alert", "Switching profile...", "OK")
      Script.SetProgress(50)
      local p = find_perm_by_id(ret)
      if p then
        switch_profile(p, db)
      else
        Script.ShowMessageBox("Error", "Selected profile not found", "OK")
      end
    end

    Script.SetProgress(100)
  end