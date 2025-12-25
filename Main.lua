scriptTitle = "Easy Launch.ini Switcher"
scriptAuthor = "Alex Portell"
scriptVersion = 1
scriptDescription = "Switch between multiple launch.ini configurations, as defined by .csv databases. github.com/portellam"
scriptIcon = "logo.png"

scriptPermissions = {
  "filesystem",
  "menusystem"
}

local MenuSystem = require("MenuSystem")

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
-- basic helpers
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
  return v == "1" or v == "true" or v == "yes"
end

local function first_non_empty(a, b)
  if a and a ~= "" then return a end
  return b
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
    if r.Name ~= "" and r.Path ~= "" then
      out[r.Name] = r.Path
    end
  end

  return out
end

local function load_directory_paths()
  local csv = read_csv(CSV.directory_paths)
  local out = {}

  for _, r in ipairs(csv.rows) do
    if r.Keyword and r.Keyword ~= "" then
      out[r.Keyword] = r.Path or ""
    end
  end

  return out
end

local function load_mount_paths()
  local csv = read_csv(CSV.mount_paths)
  local out = {}

  for _, r in ipairs(csv.rows) do
    if r.Label ~= "" and r.Path ~= "" then
      out[#out + 1] = {
        label = r.Label,
        path = r.Path,
      }
    end
  end

  return out
end

local function load_plugins()
  local csv = read_csv(CSV.plugins)
  local out = {}

  for _, r in ipairs(csv.rows) do
    if r.Name ~= "" then
      out[#out + 1] = {
        id = r.Name,
        role = r.Role or "",
      }
    end
  end

  return out
end

local function load_plugin_paths()
  local csv = read_csv(CSV.plugin_paths)
  local out = {}

  for _, r in ipairs(csv.rows) do
    if r.Plugin ~= "" and r.Keyword ~= "" then
      if not out[r.Plugin] then out[r.Plugin] = {} end
      out[r.Plugin][#out[r.Plugin] + 1] = r.Keyword
    end
  end

  return out
end

local function load_stealth_servers()
  local csv = read_csv(CSV.stealth_servers)
  local out = {}

  for _, r in ipairs(csv.rows) do
    if r.Name ~= "" then
      out[#out + 1] = {
        id = r.Name,
        backcompat = to_bool(r["Back Compat"]),
        network = to_bool(r["Stealth Network"]),
      }
    end
  end

  return out
end

local function load_stealth_paths()
  local csv = read_csv(CSV.stealth_paths)
  local out = {}

  for _, r in ipairs(csv.rows) do
    if r.Name ~= "" and r.Path ~= "" then
      out[r.Name] = r.Path
    end
  end

  return out
end

local function load_rules()
  local csv = read_csv(CSV.permutations)
  return csv.rows
end

----------------------------------------------------------------------
-- lookup helpers
----------------------------------------------------------------------

local function mount_root(mounts)
  for _, m in ipairs(mounts) do
    if m.path:lower():find("hdd:", 1, true) then
      return m.path
    end
  end
  return "Hdd:\\"
end

local function filter_dashboards(dashboards, type_name)
  if type_name == "" then
    return dashboards
  end

  if type_name == "Aurora" then
    return {
      {
        id = "Aurora",
        official = false,
        legacy = false,
        backcompat = false,
      },
    }
  end

  local out = {}

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

local function resolve_keyword_path(keyword, directory_paths)
  if not keyword or keyword == "" then
    return ""
  end

  return directory_paths[keyword] or ""
end

local function join_paths(base, rel)
  if rel == "" then
    return base
  end

  if base == "" then
    return rel
  end

  if base:sub(-1) == "\\" or base:sub(-1) == "/" then
    return base .. rel
  end

  return base .. "\\" .. rel
end

local function resolve_dashboard_target(d, dashboard_paths, dir_paths, root)
  if d.id == "Aurora" then
    local rel = resolve_keyword_path("Aurora", dir_paths)
    if rel == "" then
      return join_paths(root, "Aurora\\Aurora.xex")
    end
    return join_paths(root, rel)
  end

  local rel = dashboard_paths[d.id]
  if rel and rel ~= "" then
    return join_paths(root, rel)
  end

  local kw = resolve_keyword_path(d.id, dir_paths)
  if kw ~= "" then
    return join_paths(root, kw)
  end

  return join_paths(root, "default.xex")
end

local function resolve_stealth_plugin(stealth, stealth_paths, root)
  if not stealth or stealth.id == "NULL" then
    return ""
  end

  local rel = stealth_paths[stealth.id]
  if not rel or rel == "" then
    return ""
  end

  return join_paths(root, rel)
end

local function resolve_plugin_keywords(plugin_id, plugin_paths)
  local list = plugin_paths[plugin_id]
  if not list then
    return {}
  end
  return list
end

local function resolve_plugin_path_from_keywords(keywords, dir_paths, root)
  for _, kw in ipairs(keywords) do
    local rel = resolve_keyword_path(kw, dir_paths)
    if rel ~= "" then
      return join_paths(root, rel)
    end
  end
  return ""
end

local function select_plugins_for_permutation(plugins, plugin_paths, dir_paths, root, stealth)
  local slots = { "", "", "", "", "" }
  local used = {}

  local stealth_path = resolve_stealth_plugin(stealth, plugin_paths, root)
  if stealth_path ~= "" then
    slots[1] = stealth_path
    used[stealth_path] = true
  end

  local filled = 1
  if slots[1] == "" then
    filled = 0
  end

  for _, p in ipairs(plugins) do
    if filled >= 5 then
      break
    end

    local keywords = resolve_plugin_keywords(p.id, plugin_paths)
    local path = resolve_plugin_path_from_keywords(keywords, dir_paths, root)

    if path ~= "" and not used[path] then
      filled = filled + 1
      slots[filled] = path
      used[path] = true
    end
  end

  return slots
end

----------------------------------------------------------------------
-- permutation generation (cartesian without deep nesting)
----------------------------------------------------------------------

local function profile_name(primary, secondary, config, stealth, block_live)
  local t = {}

  t[#t + 1] = primary.id

  if secondary.id ~= primary.id then
    t[#t + 1] = "Sec:" .. secondary.id
  end

  if config.id ~= primary.id then
    t[#t + 1] = "Cfg:" .. config.id
  end

  if stealth.id ~= "NULL" then
    t[#t + 1] = "St:" .. stealth.id
  end

  if to_bool(block_live) then
    t[#t + 1] = "LiveBlock"
  end

  return table.concat(t, " | ")
end

local function cartesian_count(a, b, c, d)
  return #a * #b * #c * #d
end

local function cartesian_indices(n, len_a, len_b, len_c, len_d)
  local d_index = (n % len_d) + 1
  local c_index = (math.floor(n / len_d) % len_c) + 1
  local b_index = (math.floor(n / (len_d * len_c)) % len_b) + 1
  local a_index = (math.floor(n / (len_d * len_c * len_b)) % len_a) + 1
  return a_index, b_index, c_index, d_index
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

    if #prim > 0 and #sec > 0 and #cfg > 0 and #stl > 0 then
      local total = cartesian_count(prim, sec, cfg, stl)
      local live_block = rule["Xbox Live: Is Blocked"]

      for n = 0, total - 1 do
        local i1, i2, i3, i4 = cartesian_indices(n, #prim, #sec, #cfg, #stl)
        local p = prim[i1]
        local s = sec[i2]
        local c = cfg[i3]
        local st = stl[i4]

        idx = idx + 1
        local id = "P" .. idx

        out[#out + 1] = {
          id = id,
          name = profile_name(p, s, c, st, live_block),
          primary = p,
          secondary = s,
          config = c,
          stealth = st,
          block_live = to_bool(live_block),
          root = root,
        }
      end
    end
  end

  return out
end

----------------------------------------------------------------------
-- launch.ini generation
----------------------------------------------------------------------

local function build_launch_ini(permutation, db)
  local root = permutation.root
  local primary_path = resolve_dashboard_target(
    permutation.primary,
    db.dashboard_paths,
    db.directory_paths,
    root
  )

  local secondary_path = resolve_dashboard_target(
    permutation.secondary,
    db.dashboard_paths,
    db.directory_paths,
    root
  )

  local config_path = resolve_dashboard_target(
    permutation.config,
    db.dashboard_paths,
    db.directory_paths,
    root
  )

  local stealth_plugin = resolve_stealth_plugin(
    permutation.stealth,
    db.stealth_paths,
    root
  )

  local plugin_slots = select_plugins_for_permutation(
    db.plugins,
    db.plugin_paths,
    db.directory_paths,
    root,
    permutation.stealth
  )

  if stealth_plugin ~= "" and plugin_slots[1] == "" then
    plugin_slots[1] = stealth_plugin
  end

  local lines = {}

  lines[#lines + 1] = "[Paths]"
  lines[#lines + 1] = "default = " .. primary_path
  lines[#lines + 1] = "safexex = " .. secondary_path
  lines[#lines + 1] = "configapp = " .. config_path
  lines[#lines + 1] = ""

  lines[#lines + 1] = "[Plugins]"
  for i = 1, 5 do
    if plugin_slots[i] ~= "" then
      lines[#lines + 1] = "plugin" .. i .. " = " .. plugin_slots[i]
    else
      lines[#lines + 1] = "plugin" .. i .. " ="
    end
  end
  lines[#lines + 1] = ""

  lines[#lines + 1] = "[Settings]"
  if permutation.block_live then
    lines[#lines + 1] = "liveblock = true"
    lines[#lines + 1] = "livestrong = true"
  else
    lines[#lines + 1] = "liveblock = false"
    lines[#lines + 1] = "livestrong = false"
  end

  lines[#lines + 1] = "pingpatch = true"
  lines[#lines + 1] = "xhttp = true"

  return table.concat(lines, "\r\n")
end

----------------------------------------------------------------------
-- MenuSystem integration
----------------------------------------------------------------------

local function write_file(path, data)
  local f = io.open(path, "wb")
  if not f then
    return false
  end

  f:write(data)
  f:close()
  return true
end

local function switch_profile(p, db)
  local ini = build_launch_ini(p, db)
  local ok = write_file("Hdd:\\launch.ini", ini)

  if ok then
    MenuSystem:MessageBox("launch.ini updated", p.name)
  else
    MenuSystem:MessageBox("Error", "Failed to write launch.ini")
  end
end

local function menu_items(perms, db)
  local items = {}

  for i, p in ipairs(perms) do
    items[#items + 1] = {
      label = p.name,
      action = function()
        switch_profile(p, db)
      end,
    }
  end

  return items
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
    rules = load_rules(),
  }

  local perms = build_permutations(db)
  if #perms == 0 then
    MenuSystem:MessageBox("Error", "No permutations generated")
    return
  end

  local items = menu_items(perms, db)
  MenuSystem:OpenMenu("Launch.ini Profiles", items)
end