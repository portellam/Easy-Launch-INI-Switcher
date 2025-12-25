scriptTitle = "Easy Launch.ini Switcher"
scriptAuthor = "Alex Portell"
scriptVersion = 1
scriptDescription = "Switch between multiple launch.ini configurations, as defined by .csv databases."
scriptIcon = "icon.png"
scriptPermissions = {}

local CSV = {
  dashboards       = "csv/dashboards.csv",
  dashboard_paths  = "csv/dashboard-paths.csv",
  directory_paths  = "csv/directory-paths.csv",
  mount_paths      = "csv/mount-paths.csv",
  permutations     = "csv/permutations.csv",
  plugin_paths     = "csv/plugin-paths.csv",
  plugins          = "csv/plugins.csv",
  stealth_paths    = "csv/stealth-server-paths.csv",
  stealth_servers  = "csv/stealth-servers.csv",
}

----------------------------------------------------------------------
-- helpers
----------------------------------------------------------------------

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
  for l in f:lines() do t[#t + 1] = l end
  f:close()
  return t
end

local function read_csv(path)
  local lines = read_lines(path)
  if #lines == 0 then return { header = {}, rows = {} } end

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
  return v == "1" or v == "true" or v == "yes"
end

----------------------------------------------------------------------
-- loaders
----------------------------------------------------------------------

local function load_dashboards()
  local csv = read_csv(CSV.dashboards)
  local out = {}
  for _, r in ipairs(csv.rows) do
    if r.Name ~= "" then
      out[#out + 1] = {
        id = r.Name,
        official = to_bool(r.Official),
        legacy = to_bool(r.Legacy),
        backcompat = to_bool(r["Original Xbox"]),
      }
    end
  end
  return out
end

local function load_dashboard_paths()
  local csv = read_csv(CSV.dashboard_paths)
  local out = {}
  for _, r in ipairs(csv.rows) do
    out[r.Name] = r.Path
  end
  return out
end

local function load_directory_paths()
  local csv = read_csv(CSV.directory_paths)
  return csv.rows
end

local function load_mount_paths()
  local csv = read_csv(CSV.mount_paths)
  local out = {}
  for _, r in ipairs(csv.rows) do
    out[#out + 1] = { label = r.Label, path = r.Path }
  end
  return out
end

local function load_plugins()
  local csv = read_csv(CSV.plugins)
  local out = {}
  for _, r in ipairs(csv.rows) do
    out[#out + 1] = {
      id = r.Name,
      role = r.Role,
    }
  end
  return out
end

local function load_plugin_paths()
  local csv = read_csv(CSV.plugin_paths)
  local out = {}
  for _, r in ipairs(csv.rows) do
    if not out[r.Plugin] then out[r.Plugin] = {} end
    out[r.Plugin][#out[r.Plugin] + 1] = r.Keyword
  end
  return out
end

local function load_stealth_servers()
  local csv = read_csv(CSV.stealth_servers)
  local out = {}
  for _, r in ipairs(csv.rows) do
    out[#out + 1] = {
      id = r.Name,
      backcompat = to_bool(r["Back Compat"]),
      network = to_bool(r["Stealth Network"]),
    }
  end
  return out
end

local function load_stealth_paths()
  local csv = read_csv(CSV.stealth_paths)
  local out = {}
  for _, r in ipairs(csv.rows) do
    out[r.Name] = r.Path
  end
  return out
end

local function load_permutation_rules()
  local csv = read_csv(CSV.permutations)
  return csv.rows
end

----------------------------------------------------------------------
-- permutation logic
----------------------------------------------------------------------

local function filter_dashboards(dashboards, type_name)
  if type_name == "" then return dashboards end

  local out = {}

  if type_name == "Aurora" then
    out[1] = { id = "Aurora", official = false, legacy = false, backcompat = false }
    return out
  end

  for _, d in ipairs(dashboards) do
    if type_name == "Official" and d.official then
      out[#out + 1] = d
    elseif type_name == "Legacy" and d.legacy then
      out[#out + 1] = d
    elseif type_name == "Original Xbox" and d.backcompat then
      out[#out + 1] = d
    end
  end

  return out
end

local function filter_stealth(servers, use)
  if not to_bool(use) then
    return { { id = "NULL" } }
  end
  return servers
end

local function mount_root(mounts)
  for _, m in ipairs(mounts) do
    if m.path:lower():find("hdd:", 1, true) then
      return m.path
    end
  end
  return "Hdd:\\"
end

local function profile_name(primary, secondary, config, stealth, block_live)
  local t = {}
  t[#t + 1] = primary.id
  if secondary.id ~= primary.id then t[#t + 1] = "Sec:" .. secondary.id end
  if config.id ~= primary.id then t[#t + 1] = "Cfg:" .. config.id end
  if stealth.id ~= "NULL" then t[#t + 1] = "St:" .. stealth.id end
  if to_bool(block_live) then t[#t + 1] = "LiveBlock" end
  return table.concat(t, " | ")
end

local function build_permutations(db)
  local out = {}
  local idx = 0
  local root = mount_root(db.mount_paths)

  for _, rule in ipairs(db.rules) do
    local prim = filter_dashboards(db.dashboards, rule["Dashboard: Primary"])
    local sec  = filter_dashboards(db.dashboards, rule["Dashboard: Secondary"])
    local cfg  = filter_dashboards(db.dashboards, rule["Dashboard: ConfigApp"])
    local stl  = filter_stealth(db.stealth_servers, rule["Plugin: Use Stealth Server"])

    for _, p in ipairs(prim) do
      for _, s in ipairs(sec) do
        for _, c in ipairs(cfg) do
          for _, st in ipairs(stl) do
            idx = idx + 1
            local id = "P" .. idx
            out[#out + 1] = {
              id = id,
              name = profile_name(p, s, c, st, rule["Xbox Live: Is Blocked"]),
              path = root .. "launch_" .. id .. ".ini",
              primary = p,
              secondary = s,
              config = c,
              stealth = st,
              block_live = to_bool(rule["Xbox Live: Is Blocked"]),
            }
          end
        end
      end
    end
  end

  return out
end

----------------------------------------------------------------------
-- Aurora UI
----------------------------------------------------------------------

local function list_names(perms)
  local t = {}
  for i, p in ipairs(perms) do t[i] = p.name end
  return t
end

local function copy_file(src, dest)
  local f = io.open(src, "rb")
  if not f then return false end
  local data = f:read("*a")
  f:close()

  local w = io.open(dest, "wb")
  if not w then return false end
  w:write(data)
  w:close()
  return true
end

local function switch_profile(p)
  local ok = copy_file(p.path, "Hdd:\\launch.ini")
  if not Script or not Script.ShowMessageBox then return end
  if ok then
    Script.ShowMessageBox("OK", "Switched:\n" .. p.name, "OK")
  else
    Script.ShowMessageBox("Error", "Failed to switch", "OK")
  end
end

----------------------------------------------------------------------
-- main
----------------------------------------------------------------------

function main()
  local db = {
    dashboards = load_dashboards(),
    dashboard_paths = load_dashboard_paths(),
    directory_paths = load_directory_paths(),
    mount_paths = load_mount_paths(),
    plugins = load_plugins(),
    plugin_paths = load_plugin_paths(),
    stealth_servers = load_stealth_servers(),
    stealth_paths = load_stealth_paths(),
    rules = load_permutation_rules(),
  }

  local perms = build_permutations(db)
  if not Script or not Script.ShowPopupList then return end

  local names = list_names(perms)
  local dlg = Script.ShowPopupList(scriptTitle, "Select Profile", names)
  if dlg.Canceled then return end

  local p = perms[dlg.Selected.Key]
  if p then switch_profile(p) end
end