scriptTitle = "Easy Launch.ini Switcher"
scriptAuthor = "Alex Portell"
scriptVersion = 1.0
scriptDescription = "Switch between multiple launch.ini configurations"
scriptIcon = "icon.png"
scriptPermissions = {}

local profiles = {
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