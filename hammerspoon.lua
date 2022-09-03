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
  },
  ["apps"] = {
    ["Alacritty"] = {{"option"}, "a"},
    --["Slack"] = {{"option"}, "s"},
    --["Microsoft Remote Desktop"] = {{"option"}, "d"},
    ["Safari"] = {{"option"}, "s"},
    --["Firefox"] = {{"option"}, "f"},
    --["IntelliJ IDEA CE 2019"] = {{"option"}, "j"},
    --["IntelliJ IDEA CE"] = {{"option"}, "j"},
    --["AWS VPN Client"] = {{"option"}, "v"},
    --["zoom.us"] = {{"option"}, "z"},
    --["Google Chrome"] = {{"cmd", "option"}, "c"},
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
