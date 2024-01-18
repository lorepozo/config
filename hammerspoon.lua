--- Lore's Hammerspoon config ---

---------------
--- GLOBALS ---
---------------
hs.window.animationDuration = 0

------------
--- KEYS ---
------------
local hyper = {"ctrl", "option", "cmd", "shift"}

local keys = {
  ["specials"] = {
    ["Reload"] = {hyper, "r"},
    ["Fullscreen window"] = {hyper, "y"},
    ["Center window"] = {hyper, "k"},
    ["Left 50% window"] = {hyper, "h"},
    ["Right 50% window"] = {hyper, "l"},
    ["Move window display left"] = {hyper, "["},
    ["Move window display right"] = {hyper, "]"},
    ["RustRover"] = {{"option"}, "c"},
  },
  ["apps"] = {
    ["Alacritty"] = {{"option"}, "a"},
    ["Vivaldi"] = {{"option"}, "v"},
    ["Finder"] = {{"option"}, "f"},
  },
}

----------------
--- SPECIALS ---
----------------
local specials = {
  ["Reload"] = hs.reload,
}

specials["Fullscreen window"] = function()
  local win = hs.window.focusedWindow()
  if not win then hs.alert.show("Can't move window"); return end
  local screen = win:screen()
  local max = screen:frame()
  win:setFrame(max)
end

specials["Center window"] = function()
  local win = hs.window.focusedWindow()
  if not win then hs.alert.show("Can't move window"); return end
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()
  if max.x < 0 then
    -- If on screen on the left of the main display
    f.x = max.x + f.w / 2
  else
    f.x = (max.w - f.w) / 2
  end
  f.y = (max.h - f.h) / 2
  win:setFrame(f)
end

specials["Left 50% window"] = function()
  local win = hs.window.focusedWindow()
  if not win then hs.alert.show("Can't move window"); return end
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()
  f.x = max.x
  f.y = max.y
  f.w = max.w / 2
  f.h = max.h
  win:setFrame(f)
end

specials["Right 50% window"] = function()
  local win = hs.window.focusedWindow()
  if not win then hs.alert.show("Can't move window"); return end
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()
  if max.x < 0 then
    -- If on screen on the left of the main display
    f.x = max.x + max.w / 2
  else
    f.x = max.x2 / 2
  end
  f.y = max.y
  f.x2 = max.x2
  f.y2 = max.y2
  win:setFrame(f)
end

specials["Move window display left"] = function()
  local win = hs.window.focusedWindow()
  if not win then hs.alert.show("Can't move window"); return end
  win:moveOneScreenWest()
end

specials["Move window display right"] = function()
  local win = hs.window.focusedWindow()
  if not win then hs.alert.show("Can't move window"); return end
  win:moveOneScreenEast()
end

-- because RustRover with remote gateway can lead to multiple applications, we
-- need to handle it differently than normal apps
specials["RustRover"] = function()
  a, b = hs.application.find("RustRover")
  if b ~= nil and not b:isFrontmost() then
    b:activate()
  elseif a ~= nil then
    a:activate()
  else
    hs.application.launchOrFocus("RustRover 2023.3 EAP")
  end
end

------------
--- INIT ---
------------
function registerHotkey(name, key, fn)
  local hotkey = hs.hotkey.new(key[1], key[2], fn)
  hotkey:enable()
end

for appName, key in pairs(keys.apps) do
  registerHotkey(appName, key, function()
    hs.application.launchOrFocus(appName)
  end)
end

for specialName, key in pairs(keys.specials) do
  registerHotkey(specialName, key, specials[specialName])
end

hs.alert.show("Hammerspoon loaded!")
