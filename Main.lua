scriptTitle = "Easy Launch.ini Switcher"
scriptAuthor = "Alex Portell"
scriptVersion = 1
scriptDescription = "Switch between multiple launch.ini configurations"
scriptIcon = "icon.png"
scriptPermissions = {}

local csv = require("csv")

local CSV_DASHBOARDS      = "csv/dashboards.csv"
local CSV_DIRECTORY_PATHS = "csv/directory-paths.csv"
local CSV_MOUNT_PATHS     = "csv/mount-paths.csv"
local CSV_PERMUTATIONS    = "csv/permutations.csv"
local CSV_PLUGINS         = "csv/plugins.csv"
local CSV_PLUGIN_PATHS    = "csv/plugin-paths.csv"
local CSV_STEALTH_SERVERS = "csv/stealth-servers.csv"

----------------------------------------------------------------------
-- generic helpers
----------------------------------------------------------------------

local function trim(str)
   if not str then
      return ""
   end

   return str:match("^%s*(.-)%s*$") or ""
end

local function split_line(line, sep)
   local parts = {}

   if not line or line == "" then
      return parts
   end

   sep = sep or ","

   local pattern = "([^" .. sep .. "]*)(" .. sep .. "?)"
   local start = 1

   while true do
      local field, delimiter, finish = line:match(pattern, start)

      if not field then
         break
      end

      parts[#parts + 1] = trim(field)

      if delimiter == "" then
         break
      end

      start = finish + 1
   end

   return parts
end

local function read_all_lines(path)
   local f = io.open(path, "r")

   if not f then
      return {}
   end

   local lines = {}
   for line in f:lines() do
      lines[#lines + 1] = line
   end

   f:close()
   return lines
end

local function read_csv(path)
   local lines = read_all_lines(path)
   local result = {
      header = {},
      rows = {},
   }

   if #lines == 0 then
      return result
   end

   local header = split_line(lines[1])
   result.header = header

   for i = 2, #lines do
      local line = lines[i]
      local cols = split_line(line)
      local row = {}

      for idx, name in ipairs(header) do
         row[name] = cols[idx] or ""
      end

      result.rows[#result.rows + 1] = row
   end

   return result
end

local function index_rows(rows, col_name)
   local index = {}

   for _, row in ipairs(rows) do
      local key = row[col_name]

      if key and key ~= "" then
         index[key] = row
      end
   end

   return index
end

local function to_bool(str)
   if not str then
      return false
   end

   local s = str:lower()
   if s == "true" or s == "yes" or s == "1" then
      return true
   end

   return false
end

----------------------------------------------------------------------
-- database loaders
----------------------------------------------------------------------

local function load_dashboards()
   local csv = read_csv(CSV_DASHBOARDS)
   local rows = csv.rows
   local items = {}

   for _, row in ipairs(rows) do
      local name = row.Name or row.Dashboard or row["Dashboard Name"]

      if name and name ~= "" then
         items[#items + 1] = {
            id = name,
            name = name,
            official = to_bool(row.Official or row["Is Official"]),
            legacy = to_bool(row.Legacy or row["Is Legacy"]),
            original_xbox = to_bool(row["Original Xbox"]),
         }
      end
   end

   return items
end

local function load_mount_paths()
   local csv = read_csv(CSV_MOUNT_PATHS)
   local rows = csv.rows
   local items = {}

   for _, row in ipairs(rows) do
      local label = row.Label or row.Name or row.Mount

      if label and label ~= "" then
         items[#items + 1] = {
            label = label,
            path = row.Path or row["Mount Path"] or "",
         }
      end
   end

   return items
end

local function load_directory_paths()
   local csv = read_csv(CSV_DIRECTORY_PATHS)
   local rows = csv.rows
   local items = {}

   for _, row in ipairs(rows) do
      items[#items + 1] = row
   end

   return items
end

local function load_plugins()
   local csv = read_csv(CSV_PLUGINS)
   local rows = csv.rows
   local items = {}

   for _, row in ipairs(rows) do
      local name = row.Name or row.Plugin

      if name and name ~= "" then
         items[#items + 1] = {
            id = name,
            name = name,
            type = row.Type or row.Role or "",
         }
      end
   end

   return items
end

local function load_plugin_paths()
   local csv = read_csv(CSV_PLUGIN_PATHS)
   local rows = csv.rows
   local items = {}

   for _, row in ipairs(rows) do
      local plugin = row.Plugin or row.Name

      if plugin and plugin ~= "" then
         items[#items + 1] = {
            plugin = plugin,
            keyword = row.Keyword or row["Directory Keyword"] or "",
         }
      end
   end

   return items
end

local function load_stealth_servers()
   local csv = read_csv(CSV_STEALTH_SERVERS)
   local rows = csv.rows
   local items = {}

   for _, row in ipairs(rows) do
      local name = row.Name or row.Server

      if name and name ~= "" then
         items[#items + 1] = {
            id = name,
            name = name,
            freeware = to_bool(row.Freeware),
            shareware = to_bool(row.Shareware),
            paid = to_bool(row.Paid),
            backcompat = to_bool(row["Back Compat"]),
            cheats = to_bool(row.Cheats),
            network = to_bool(row["Stealth Network"]),
         }
      end
   end

   return items
end

local function load_permutation_matrix()
   local csv = read_csv(CSV_PERMUTATIONS)
   local rows = csv.rows
   local items = {}

   for _, row in ipairs(rows) do
      local primary = row["Dashboard: Primary"] or row["Primary"]
      local secondary = row["Dashboard: Secondary"] or row["Secondary"]
      local config = row["Dashboard: ConfigApp"] or row["ConfigApp"]
      local use_stealth = row["Plugin: Use Stealth Server"] or row["Use Stealth"]
      local block_live = row["Xbox Live: Is Blocked"] or row["Block Live"]

      items[#items + 1] = {
         primary_type = primary or "",
         secondary_type = secondary or "",
         config_type = config or "",
         use_stealth = to_bool(use_stealth),
         block_live = to_bool(block_live),
      }
   end

   return items
end

----------------------------------------------------------------------
-- permutation builders
----------------------------------------------------------------------

local function dashboards_by_flag(dashboards, flag_name, flag_value)
   local result = {}

   for _, d in ipairs(dashboards) do
      local value = d[flag_name]

      if value == flag_value then
         result[#result + 1] = d
      end
   end

   return result
end

local function dashboards_all(dashboards)
   local result = {}

   for _, d in ipairs(dashboards) do
      result[#result + 1] = d
   end

   return result
end

local function select_dashboards_by_type(dashboards, type_name)
   if type_name == "" then
      return dashboards_all(dashboards)
   end

   if type_name == "Aurora" then
      return {
         {
            id = "Aurora",
            name = "Aurora",
            official = false,
            legacy = false,
            original_xbox = false,
         },
      }
   end

   if type_name == "Official" then
      return dashboards_by_flag(dashboards, "official", true)
   end

   if type_name == "Legacy" then
      return dashboards_by_flag(dashboards, "legacy", true)
   end

   if type_name == "Original Xbox" then
      return dashboards_by_flag(dashboards, "original_xbox", true)
   end

   return dashboards_all(dashboards)
end

local function select_stealth_servers(servers, use_stealth)
   local result = {}

   if not use_stealth then
      result[#result + 1] = {
         id = "NULL",
         name = "No Stealth Server",
      }

      return result
   end

   for _, server in ipairs(servers) do
      result[#result + 1] = server
   end

   return result
end

local function resolve_mount_root(mount_paths)
   for _, m in ipairs(mount_paths) do
      local path = m.path:lower()

      if path:find("hdd:", 1, true) then
         return m.path
      end
   end

   return "Hdd:\\"
end

local function build_plugin_lookup(plugin_paths)
   local map = {}

   for _, p in ipairs(plugin_paths) do
      if not map[p.plugin] then
         map[p.plugin] = {}
      end

      map[p.plugin][#map[p.plugin] + 1] = p.keyword
   end

   return map
end

local function format_profile_name(primary, secondary, config, stealth, block_live)
   local parts = {}

   parts[#parts + 1] = primary.name

   if secondary.id ~= primary.id then
      parts[#parts + 1] = "Sec:" .. secondary.name
   end

   if config.id ~= primary.id then
      parts[#parts + 1] = "Cfg:" .. config.name
   end

   if stealth.id ~= "NULL" then
      parts[#parts + 1] = "St:" .. stealth.name
   else
      parts[#parts + 1] = "No Stealth"
   end

   if block_live then
      parts[#parts + 1] = "Live Block"
   else
      parts[#parts + 1] = "Live OK"
   end

   return table.concat(parts, " | ")
end

local function build_profile_id(index)
   return "P" .. tostring(index)
end

local function build_launch_ini_path(root, id)
   return root .. "launch_" .. id .. ".ini"
end

local function build_permutations(db)
   local dashboards = db.dashboards
   local stealth_servers = db.stealth_servers
   local matrix = db.permutation_matrix
   local mount_paths = db.mount_paths

   local root = resolve_mount_root(mount_paths)
   local permutations = {}
   local idx = 0

   for _, rule in ipairs(matrix) do
      local primaries = select_dashboards_by_type(dashboards, rule.primary_type)
      local secondaries = select_dashboards_by_type(dashboards, rule.secondary_type)
      local configs = select_dashboards_by_type(dashboards, rule.config_type)
      local stealths = select_stealth_servers(stealth_servers, rule.use_stealth)

      for _, primary in ipairs(primaries) do
         for _, secondary in ipairs(secondaries) do
            for _, config in ipairs(configs) do
               for _, stealth in ipairs(stealths) do
                  idx = idx + 1
                  local id = build_profile_id(idx)
                  local name = format_profile_name(primary, secondary, config, stealth, rule.block_live)
                  local path = build_launch_ini_path(root, id)

                  permutations[#permutations + 1] = {
                     id = id,
                     primary = primary,
                     secondary = secondary,
                     config = config,
                     stealth = stealth,
                     block_live = rule.block_live,
                     path = path,
                     name = name,
                  }
               end
            end
         end
      end
   end

   return permutations
end

----------------------------------------------------------------------
-- aurora helpers
----------------------------------------------------------------------

local function permutations_to_list(permutations)
   local list = {}

   for i, p in ipairs(permutations) do
      list[i] = p.name
   end

   return list
end

local function copy_file(src, dest)
   local in_file = io.open(src, "rb")

   if not in_file then
      return false, "Source not found: " .. src
   end

   local data = in_file:read("*a")
   in_file:close()

   local out_file = io.open(dest, "wb")
   if not out_file then
      return false, "Cannot write: " .. dest
   end

   out_file:write(data)
   out_file:close()

   return true
end

local function switch_launch_profile(profile)
   local ok, err = copy_file(profile.path, "Hdd:\\launch.ini")

   if not Script or not Script.ShowMessageBox then
      return
   end

   if ok then
      Script.ShowMessageBox(
         "Profile Switched",
         "Now using:\n" .. profile.name .. "\nReboot to apply.",
         "OK"
      )

      return
   end

   Script.ShowMessageBox(
      "Error",
      "Failed to switch profile:\n" .. err,
      "OK"
   )
end

----------------------------------------------------------------------
-- main
----------------------------------------------------------------------

function main()
   local dashboards = load_dashboards()
   local directory_paths = load_directory_paths()
   local mount_paths = load_mount_paths()
   local plugins = load_plugins()
   local plugin_paths = load_plugin_paths()
   local stealth_servers = load_stealth_servers()
   local permutation_matrix = load_permutation_matrix()

   local plugin_lookup = build_plugin_lookup(plugin_paths)

   local db = {
      dashboards = dashboards,
      directory_paths = directory_paths,
      mount_paths = mount_paths,
      plugins = plugins,
      plugin_paths = plugin_paths,
      plugin_lookup = plugin_lookup,
      stealth_servers = stealth_servers,
      permutation_matrix = permutation_matrix,
   }

   local permutations = build_permutations(db)

   if not Script or not Script.ShowPopupList then
      return
   end

   local names = permutations_to_list(permutations)
   local dialog = Script.ShowPopupList(scriptTitle, "Select launch.ini profile", names)

   if dialog.Canceled then
      return
   end

   local index = dialog.Selected.Key
   local profile = permutations[index]

   if not profile then
      return
   end

   switch_launch_profile(profile)
end