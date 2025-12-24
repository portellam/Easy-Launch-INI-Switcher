scriptTitle = "Easy Launch.ini Switcher"
scriptAuthor = "Alex Portell"
scriptVersion = 1.0
scriptDescription = "Switch between multiple launch.ini configurations"
scriptIcon = "icon.png"
scriptPermissions = {}

local dashboard_dir_paths = [
  "app",
  "application",
  "applications",
  "dash",
  "dashboard",
  "dashboards",
  "homebrew"
]

local dashboard_xex_paths = {
  aurora = {
    executable = "Aurora.xex",
    folder_substrings = [ "Aurora" ]
  },
  blades = {
    executable = "dash.xex",
    folder_substrings = [
      "blades",
      "microsoft",
      "retail"
    ]
  },
  kinect = {
    executable = "dash.xex",
    folder_substrings = [
      "kinect",
      "microsoft",
      "retail"
    ]
  },
  metro = {
    executable = "dash.xex",
    folder_substrings = [
      "metro",
      "microsoft",
      "retail"
    ]
  },
  nxe = {
    executable = "dash.xex",
    folder_substrings = [
      "nxe",
      "new xbox experience",
      "microsoft",
      "retail"
    ]
  }
}

local plugin_dir_paths = [
  "app",
  "application",
  "applications",
  "homebrew",
  "plugin",
  "plugins"
]

local plugin_type_paths = {
  developer_tools = [
    "dev",
    "dev-tool",
    "dev-tools",
    "developer",
    "developer-tool",
    "developer-tools",
    "tool",
    "tools"
  ],
  lan_servers = [
    "lan",
    "local-net",
    "local-area-network",
    "lan-server",
    "lan-servers",
    "local-server",
    "local-servers",
    "local-net-server",
    "local-net-servers",
    "local-network-server",
    "local-network-servers",
    "local-network-server",
    "local-network-servers",
    "server",
    "servers"
  ],
  lan_debug_tools = [
    "debug",
    "debugging",
    "debug-tools",
    "debugging-tools"
  ],
  patches = [
    "patch",
    "patches"
  ],
  hud = [
    "hud",
    "heads-up-display",
    "guide",
    "guide-menu",
    "ui",
    "user-interface"
  ],
  stealth_servers = [
    "server",
    "servers",
    "stealth-server",
    "stealth-servers"
  ]
}

local stealth_server_xex_paths = {
  cipher = {
    executable = "cipher.xex",
    folder_substrings = [
      "cipher",
      "cipher-badavatar",
      "cipher-badupdate",
      "cipher-hdd",
      "cipher-usb",
    ]
  },
  proto = {
    executable = "proto.xex",
    folder_substrings = [ "proto" ]
  },
  xbguard = {
    executable = "xbguard.xex",
    folder_substrings = [
      "xbguard",
      "xbguard/hdd",
      "xbguard/usb"
    ]
  }
}

local retail_dashboards = {
  blades = {
    short_name = "Blades",
    long_name = short_name,
    minimum_revision = 1888,
  },
  nxe = {
    short_name = "NXE",
    long_name = "New Xbox Experience (NXE)",
    minimum_revision = 7357,
  },
  kinect = {
    short_name = "Kinect",
    long_name = short_name .. " (NXE v2)",
    minimum_revision = 12611,
  },
  metro = {
    short_name = "Metro",
    long_name = short_name,
    minimum_revision = 14699,
  }
}

local stealth_servers = {
  cipher = {
    backwards_compatible = true,
    executable = "Cipher.xex",
    internet_required = true,
    legacy_dashboard_compatible = true
  },
  proto = {
    backwards_compatible = false,
    executable = "Proto.xex",
    internet_required = false,
    legacy_dashboard_compatible = true
  },
  xbguard = {
    backwards_compatible = false,
    executable = "XbGuard.xex",
    internet_required = true,
    legacy_dashboard_compatible = true
  }
}

local function validate_dashboard_path(
  dashboard_name,
  path,
  revision
)
  local dashboard_info = dashboard_xex_paths[dashboard_name]
  if not dashboard_info then
    return false, "Dashboard not found"
  end

  local retail_info = retail_dashboards[dashboard_name]
  if retail_info then
    if revision < retail_info.minimum_revision then
      return false, "Minimum revision not met"
    end
  end

  local folder_name = path:match(".*/(.-)/") or path
  for _, valid_dir in ipairs(dashboard_dir_paths) do
    if folder_name:find(valid_dir) then
      break
    end
  end

  if dashboard_info.executable == "dash.xex" or dashboard_info.executable == "default.xex" then
    if not path:find(dashboard_info.executable) and not path:find(folder_name) then
      return false, "Executable not found in path"
    end
  else
    for _, substring in ipairs(dashboard_info.folder_substrings) do
      if path:find(substring) then
      return true, "Valid path"
      end
    end
  end

  return false, "Invalid path"
end

local is_valid, message = validate_dashboard_path("blades", "/path/to/microsoft/blades/", 1900)
print(message)

---

local filters = {
  backwards_compatible_preferred = true,
  xbox_live_blocked_preferred = true
}

local function generate_permutations()
  local permutations = {}

  local live_access = not filters.xbox_live_blocked_preferred
  local block_live = filters.xbox_live_blocked_preferred
  local backwards_compat = filters.backwards_compatible_preferred

  local possible_stealth = {}

  for name, props in pairs(stealth_servers) do
    if props.backwards_compatible == backwards_compat then
      table.insert(possible_stealth, name)
    end
  end
  if backwards_compat and block_live then
    table.insert(possible_stealth, "NULL")
  end

  for _, dashboard in ipairs(dashboards) do
    local config_app = (dashboard == "Aurora") and "Metro" or "*Primary*"
    local secondary_dashboard = "*Primary*"
    local is_legacy = (dashboard ~= "Metro" and dashboard ~= "Aurora")
    local works = is_legacy and "TODO" or "Confirmed true."

    for _, stealth in ipairs(possible_stealth) do
      if live_access and stealth == "NULL" then goto continue end

      local internet_required = (stealth == "NULL") and false or stealth_servers[stealth].internet_required

      table.insert(permutations, {
        live_access = live_access,
        backwards_compat = backwards_compat,
        primary_dashboard = dashboard,
        secondary_dashboard = secondary_dashboard,
        config_app = config_app,
        stealth_plugin = stealth,
        block_live = block_live,
        internet_required = internet_required,
        works = works
      })
      ::continue::
    end
  end

  return permutations
end



local function set_profile_name(
  primary_dashboard_name,
  secondary_dashboard_name,
  legacy_dashboard_compatible,
  original_xbox_compatible,
  stealth_server_name,
  online_required,
  xbox_live_blocked
)
  legacy_dashboard_compatible_str="No Old Dash"

  if (legacy_dashboard_compatible)
    legacy_dashboard_compatible_str="Yes Old Dash"

  online_required_str="Online Optional"

  if (online_required)
    online_required_str="Online Only"

  original_xbox_compatible_str="No Back Compat"

  if (original_xbox_compatible)
    original_xbox_compatible_str="Yes Back Compat"

  original_xbox_compatible_str="No Back Compat"

  if (original_xbox_compatible)
    original_xbox_compatible_str="Yes Back Compat"

  name = primary_dashboard_name .. " + " .. legacy_dashboard_compatible_str ..
    " + " .. original_xbox_compatible_str .. " + " .. 


local profiles = {
  {
    stealth_server = "proto"
    name = "New Xbox Experience (NXE)" + capitalize_string("proto")

  }

   {
      name = "Aurora (Default)",
      path = "Hdd:\\launch.ini",
      description = "Standard Aurora dashboard with default settings"
   },
   {
      name = "NXE (Freestyle)",
      path = "Hdd:\\launch_nxe.ini",
      description = "Launch to NXE dashboard"
   },
   {
      name = "Stealth (Proto)",
      path = "Hdd:\\launch_stealth.ini",
      description = "Stealth server enabled for online"
   },
   {
      name = "Original Xbox Compat",
      path = "Hdd:\\launch_compat.ini",
      description = "Optimized for original Xbox emulation"
   }
}

local function capitalize_string(str)
  str = string.upper(string.sub(str, 1, 1)) .. string.sub(str, 2)
  return str

local function copy_file(src, dest)
   local in_file = io.open(src, "rb")
   if not in_file then
      return false, "Source file not found"
   end

   local content = in_file:read("*a")
   in_file:close()

   local out_file = io.open(dest, "wb")
   if not out_file then
      return false, "Cannot write destination"
   end

   out_file:write(content)
   out_file:close()
   return true
end

local function get_profile_names()
   local names = {}
   for i, profile in ipairs(profiles) do
      names[i] = profile.name
   end
   return names
end

local function switch_to_profile(index)
   if index < 1 or index > #profiles then
      return false
   end

   local profile = profiles[index]
   local ok, err = copy_file(profile.path, "Hdd:\\launch.ini")
   if ok then
      Script.ShowMessageBox("Success", "Switched to " .. profile.name .. "\nReboot to apply.", "OK")
   else
      Script.ShowMessageBox("Error", "Failed: " .. err, "OK")
   end
end

function main()
   local names = get_profile_names()
   local dialog = Script.ShowPopupList(scriptTitle, "Select profile", names)

   if not dialog.Canceled then
      switch_to_profile(dialog.Selected.Key)
   end
end