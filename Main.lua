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

  local print_alert = "ALERT"
  local print_error = "ERROR"
  local print_failure = "FAILURE"
  local print_success = "SUCCESS"

  local print_ok = "OK"
  local print_yes = "Yes"
  local print_no = "No"

  require("MenuSystem");

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

  local launch_ini_name = "launch.ini"
  local launch_ini_backup_name = launch_ini_name .. ".old"
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
    if not s then
      return ""
    end

    return s:match("^%s*(.-)%s*$")
        or ""
  end

  local function split(
    line,
    sep
  )
    if not line then
      return {}
    end

    sep = sep or ","
    local out = {}

    for field in line:gmatch("([^" .. sep .. "]+)") do
      out[#out + 1] = trim(field)
    end

    return out
  end

  local function read_lines(path)
    local f = io.open(
      path,
      "r"
    )

    if not f then
      return {}
    end

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
      return {
        header = {},
        rows = {}
      }
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

    return {
      header = header,
      rows = rows
    }
  end

  local function to_bool(v)
    if not v then
      return false
    end

    v = v:lower()

    return v == "1"
        or v == "true"
        or v == "yes"
        or v == "y"
  end

  local function to_nil_if_null(v)
    if v == nil or v == "" or v == "NULL" then
      return nil
    end

    return v
  end

--[[ launch.ini location detection ]]
  local function detect_launch_ini_location()
    local known_mounts = {
      "Mu:\\",
      "Usb:\\",
      "UsbMu:\\",
      "Hdd:\\",
      "IntMu:\\",
      "MmcMu:\\",
      "FlashMu:\\"
    }

    for _, mount in ipairs(known_mounts) do
      local candidate = mount .. launch_ini_name

      if FileSystem.FileExists(candidate) then
        return candidate,
               mount .. launch_ini_backup_name
      end
    end

    local csv = read_csv(CSV.mount_paths)

    for _, row in ipairs(csv.rows) do
      if row.Path then
        local mount = row.Path

        if mount:sub(-1) ~= "\\" then
          mount = mount .. "\\"
        end

        local candidate = mount .. launch_ini_name

        if FileSystem.FileExists(candidate) then
          return candidate,
                 mount .. launch_ini_backup_name
        end
      end
    end

    return nil
  end

  local function get_root_from_launch_path()
    if not launch_ini_path then
      return "Hdd:\\"
    end

    return launch_ini_path:match("^(.-)[^\\/]+%.ini$")
        or "Hdd:\\"
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
          min_version = to_nil_if_null(r["MinimumVersion"]),
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
        out[r.Name] = {
          path = r.Path or "",
          exe = r.Executable or ""
        }
      end
    end

    return out
  end

  local function load_executables()
    local csv = read_csv(CSV.executables)
    local out = {}

    for _, r in ipairs(csv.rows) do
      if r.Executable ~= "" then
        out[#out + 1] = r.Executable
      end
    end

    return out
  end

  local function load_plugins()
    local csv = read_csv(CSV.plugins)
    local out = {}

    for _, r in ipairs(csv.rows) do
      out[#out + 1] = {
        index = tonumber(r.Index),
        id = r.Name,
        max = tonumber(r["MaximumCount"])
      }
    end

    return out
  end

  local function load_plugin_paths()
    local csv = read_csv(CSV.plugin_paths)
    local out = {}

    for _, r in ipairs(csv.rows) do
      if r.Name and r.Keyword then
        out[r.Name] = out[r.Name] or {}

        table.insert(
          out[r.Name],
          r.Keyword
        )
      end
    end

    return out
  end

  local function load_stealth_servers()
    local csv = read_csv(CSV.stealth_servers)
    local out = {}

    for _, r in ipairs(csv.rows) do
      local s = {}

      for k, v in pairs(r) do
        s[k] = to_bool(v)
      end

      out[r.Name] = s
    end

    return out
  end

  local function load_stealth_paths()
    local csv = read_csv(CSV.stealth_paths)
    local out = {}

    for _, r in ipairs(csv.rows) do
      out[r.Name] = out[r.Name] or {}

      table.insert(
        out[r.Name],
        {
          path = r.Path or "",
          exe = r.Executable or ""
        }
      )
    end

    return out
  end

  local function load_rules()
    return read_csv(CSV.permutations).rows
  end

  local function resolve_abstract_dashboard(id, db)
    if not id then
      return nil
    end

    if db.dashboard_paths[id] or id == "Aurora" then
      return { id = id }
    end

    if id == "Official" then
      for _, d in ipairs(db.dashboards) do
        if d.official and not d.legacy then
          return { id = d.id }
        end
      end
    elseif id == "Legacy" then
      for _, d in ipairs(db.dashboards) do
        if d.legacy then
          return { id = d.id }
        end
      end
    end

    return nil
  end

  local function build_permutations(db)
    local out = {}
    local root = get_root_from_launch_path()

    local stealth_order = {}

    for name, s in pairs(db.stealth_servers) do
      local score = 0

      if s["AvailabilityPaid"] then
        score = score + 4
      end

      if s["AvailabilityShareware"] then
        score = score + 3
      end

      if s["AvailabilityFreeware"] then
        score = score + 2
      end

      if s["BackwardsCompatibilitySupport"] then
        score = score + 1
      end

      table.insert(
        stealth_order,
        { name = name, score = score }
      )
    end

    table.sort(
      stealth_order,
      function(a, b)
        return a.score > b.score
      end
    )

    for i, rule in ipairs(db.rules) do
      local primary_id = to_nil_if_null(rule["DashboardPrimary"])
      local secondary_id = to_nil_if_null(rule["DashboardSecondary"])
      local config_id = to_nil_if_null(rule["DashboardConfigApp"])
      local use_stealth = to_bool(rule["UseStealthServer"])
      local block_live = to_bool(rule["BlockXboxLive"])

      local primary = resolve_abstract_dashboard(
        primary_id,
        db
      )

      local secondary = secondary_id and resolve_abstract_dashboard(
        secondary_id,
        db
      ) or nil

      local config = config_id and resolve_abstract_dashboard(
        config_id,
        db
      ) or nil

      if not primary then
        goto continue
      end

      local stealth = nil

      if use_stealth and #stealth_order > 0 then
        stealth = { id = stealth_order[1].name }
      else
        stealth = { id = "NULL" }
      end

      local name = primary.id

      if secondary then
        name = name .. " → " .. secondary.id
      end

      if use_stealth and stealth.id ~= "NULL" then
        name = name .. " + " .. stealth.id
      end

      if block_live then
        name = name .. " (Live Blocked)"
      end

      out[#out + 1] = {
        id = i,
        name = name,
        primary = primary,
        secondary = secondary,
        config = config,
        stealth = stealth,
        block_live = block_live,
        root = root
      }

      ::continue::
    end

    return out
  end

--[[ lookup helpers ]]
  local function join_paths(
    base,
    rel
  )
    if not rel or rel == "" then
      return base
          or ""
    end

    if not base or base == "" then
      return rel
    end

    if base:sub(-1) == "\\" then
      return base .. rel
    end

    return base .. "\\" .. rel
  end

  local function resolve_dashboard_target(
    d,
    dashboard_paths,
    dir_paths,
    root,
    executables
  )
    if not d then
      return ""
    end

    local info = dashboard_paths[d.id]

    if info then
      local full_path = join_paths(
        root,
        info.path
      )

      if info.exe ~= "" then
        return join_paths(
          full_path,
          info.exe
        )

      elseif info.path ~= "" then
        return join_paths(
          full_path,
          executables[1] or "dash.xex"
        )
      end
    end

    local kw_path = dir_paths[d.id] or dir_paths["Dashboard"] or ""

    if kw_path ~= "" then
      return join_paths(
        root,
        join_paths(
          kw_path,
          executables[1] or "dash.xex"
        )
      )
    end

    return join_paths(
      root,
      executables[1] or "dash.xex"
    )
  end

  local function resolve_stealth_plugin(
    stealth,
    stealth_paths,
    root
  )
    if not stealth or stealth.id == "NULL" then
      return ""
    end

    local entries = stealth_paths[stealth.id]

    if not entries or #entries == 0 then
      return ""
    end

    local e = entries[1]

    return join_paths(
      root,
      join_paths(
        e.path,
        e.exe
      )
    )
  end

  local function resolve_plugin_keywords(
    plugin_id,
    plugin_paths
  )
    return plugin_paths[plugin_id] or {}
  end

  local function resolve_plugin_path_from_keywords(
    keywords,
    dir_paths,
    root
  )
    for _, kw in ipairs(keywords) do
      local rel = dir_paths[kw]

      if rel and rel ~= "" then
        return join_paths(
          root,
          rel
        )
      end
    end

    return ""
  end

  local function select_plugins_for_permutation(
    plugins,
    plugin_paths,
    dir_paths,
    root,
    stealth
  )
    local slots = { "", "", "", "", "" }
    local used_paths = {}
    local counts = { Debug = 0, LAN = 0, Stealth = 0, Patch = 0, UI = 0 }

    local stealth_path = ""

    if stealth and stealth.id ~= "NULL" then
      stealth_path = resolve_stealth_plugin(
        stealth,
        db.stealth_paths,
        root
      )
    end

    for _, p in ipairs(plugins) do
      if counts[p.id] >= p.max then
        goto next
      end

      local keywords = resolve_plugin_keywords(
        p.id,
        plugin_paths
      )

      local path = resolve_plugin_path_from_keywords(
        keywords,
        dir_paths,
        root
      )

      if path == "" then
        goto next
      end

      local slot_idx = p.index + 1

      if slots[slot_idx] == "" and not used_paths[path] then
        slots[slot_idx] = path
        used_paths[path] = true
        counts[p.id] = counts[p.id] + 1
      end

      ::next::
    end

    for _, p in ipairs(plugins) do
      if counts[p.id] >= p.max then
        goto next2
      end

      local keywords = resolve_plugin_keywords(
        p.id,
        plugin_paths
      )

      local path = resolve_plugin_path_from_keywords(
        keywords,
        dir_paths,
        root
      )

      if path == "" or used_paths[path] then
        goto next2
      end

      for i = 1, 5 do
        if slots[i] == "" then
          slots[i] = path
          used_paths[path] = true
          counts[p.id] = counts[p.id] + 1
          break
        end
      end

      ::next2::
    end

    if stealth_path ~= "" and not used_paths[stealth_path] then
      for i = 1, 5 do
        if slots[i] == "" then
          slots[i] = stealth_path
          used_paths[stealth_path] = true
          break
        end
      end
    end

    return slots
  end

--[[ launch.ini generation ]]
  local function backup_launch_ini()
    if FileSystem.FileExists(launch_ini_path) then
      if FileSystem.FileExists(launch_ini_backup_path) then
        FileSystem.DeleteFile(launch_ini_backup_path)
      end

      FileSystem.CopyFile(
        launch_ini_path,
        launch_ini_backup_path,
        false
      )
    end

    return true
  end

  local function build_launch_ini(
    permutation,
    db
  )
    local root = permutation.root
    local executables = db.executables or {"dash.xex"}

    local primary_path   = resolve_dashboard_target(
      permutation.primary,
      db.dashboard_paths,
      db.directory_paths,
      root,
      executables
    )

    local secondary_path = resolve_dashboard_target(
      permutation.secondary,
      db.dashboard_paths,
      db.directory_paths,
      root,
      executables
    )

    local config_path    = resolve_dashboard_target(
      permutation.config,
      db.dashboard_paths,
      db.directory_paths,
      root,
      executables
    )

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
      table.remove(lines, #lines - 1)
      table.remove(lines, #lines)
    end

    lines[#lines + 1] = "[Settings]"
    lines[#lines + 1] = "liveblock = " .. (permutation.block_live and "true" or "false")
    lines[#lines + 1] = "livestrong = " .. (permutation.block_live and "true" or "false")
    lines[#lines + 1] = "pingpatch = true"
    lines[#lines + 1] = "xhttp = true"

    return table.concat(lines, "\r\n")
  end

--[[ MenuSystem integration ]]
  local function write_file(
    path,
    data
  )
    local f = io.open(
      path,
      "wb"
    )

    if not f then
      return false
    end

    f:write(data)
    f:close()
    return true
  end

  local function switch_permutation(
    p,
    db
  )
    local ini = build_launch_ini(
      p,
      db
    )

    local ok = write_file(
      launch_ini_path,
      ini
    )

    if ok then
      Script.ShowMessageBox(
        print_success,
        "\"" .. launch_ini_name .. "\" updated to: " .. p.name .. "\n\nReboot required for changes to take effect.",
        print_ok
      )

      Script.ShowNotification("\"" .. launch_ini_name .. "\" updated to " .. p.name)
    else
      Script.ShowMessageBox(
        print_error,
        "Failed to write \"" .. launch_ini_name .. "\" at:\n" .. launch_ini_path,
        print_ok
      )
    end
  end

  local function find_perm_by_id(id)
    for _, p in ipairs(perms) do
      if p.id == id then
        return p
      end
    end

    return nil
  end

--[[ script helpers ]]
  function set_progress(
    divisor,
    increment
  )
    if divisor == nil or divisor < 0 then
      divisor = 1
    end

    if increment == nil or increment < 0 then
      increment = 1
    end

    local val = 100 / divisor * increment

    if val > 100 then
      val = 100
    end

    Script.SetProgress(val)
  end

  function init()
    Script.SetProgress(0)
    progress_steps = #CSV + 4

    local msg = "Detecting \"" .. launch_ini_name .. "\""
    Script.SetStatus(msg .. "...")
    launch_ini_path, launch_ini_backup_path = detect_launch_ini_location()

    if not launch_ini_path then
      Script.ShowMessageBox(
        print_error,
        msg .. " failed. File not found or is not valid.",
        print_ok
      )

      return false
    end

    set_progress(
      progress_steps,
      1
    )

    msg = "Backing up \"" .. launch_ini_name .. "\""
    Script.SetStatus(msg .. "...")

    if not backup_launch_ini() then
      local ret = Script.ShowMessageBox(
        print_error,
        msg .. " failed.\n\nContinue?",
        print_no,
        print_yes
      );

      if ret.Canceled or ret.Button ~= 2 then
        return false
      end
    end

    set_progress(
      progress_steps,
      2
    )

    Script.SetStatus("Parsing databases...")

    db.directory_paths = load_directory_paths()

    set_progress(
      progress_steps,
      3
    )

    db.mount_paths = load_mount_paths()

    set_progress(
      progress_steps,
      4
    )

    db.dashboards = load_dashboards()

    set_progress(
      progress_steps,
      5
    )
    db.dashboard_paths = load_dashboard_paths()

    set_progress(
      progress_steps,
      6
    )

    db.executables = load_executables()

    set_progress(
      progress_steps,
      7
    )

    db.plugins = load_plugins()

    set_progress(
      progress_steps,
      8
    )

    db.plugin_paths = load_plugin_paths()

    set_progress(
      progress_steps,
      9
    )

    db.stealth_servers = load_stealth_servers()

    set_progress(
      progress_steps,
      10
    )

    db.stealth_paths = load_stealth_paths()

    set_progress(
      progress_steps,
      11
    )

    db.rules = load_rules()

    set_progress(
      progress_steps,
      12
    )

    if #db.rules == 0 then
      Script.ShowMessageBox(
        print_error,
        "Permutations database either does not exist, is empty, or is not valid.",
        print_ok
      )

      return false
    end

    set_progress(
      progress_steps,
      13
    )

    perms = build_permutations(db)

    if #perms == 0 then
      Script.ShowMessageBox(
        print_error,
        "No valid permutations could be built.",
        print_ok
      )

      return false
    end

    Script.SetProgress(100)
    return true
  end

  function MakeMainMenu()
    Menu.SetTitle(scriptTitle)
    Menu.SetGoBackText("Cancel")

    Menu.AddMainMenuItem(
      Menu.MakeMenuItem(
        "<Reset to Original>",
        "RESET"
      )
    )

    for _, p in ipairs(perms) do
      Menu.AddMainMenuItem(
        Menu.MakeMenuItem(
          p.name,
          p.id
        )
      )
    end
  end

  function DoShowMenu()
    local ret, _, canceled = Menu.ShowMainMenu()

    if canceled or ret == nil then
      return
    end

    Script.SetProgress(25)

    if ret == "RESET" then
      if FileSystem.FileExists(launch_ini_backup_path) then
        FileSystem.CopyFile(
          launch_ini_backup_path,
          launch_ini_path,
          true
        )

        Script.ShowMessageBox(
          print_success,
          "Restored \"" .. launch_ini_name .. "\" from backup.\n\nReboot required.",
          print_ok
        )

        Script.ShowNotification("Restored from backup.")
      else
        Script.ShowMessageBox(
          print_error,
          "No backup found to restore.",
          print_ok
        )
      end
    else
      Script.ShowMessageBox(
        print_alert,
        "Switching permutation...",
        print_ok
      )

      Script.SetProgress(50)

      local p = find_perm_by_id(ret)

      if p then
        switch_permutation(
          p,
          db
        )

      else
        Script.ShowMessageBox(
          print_error,
          "Selected permutation not found.",
          print_ok
        )
      end
    end

    Script.SetProgress(100)
  end