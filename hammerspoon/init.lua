-- most config is taken from 
-- https://github.com/derekwyatt/dotfiles/blob/master/hammerspoon-init.lua
-- and slightly modified
units = {
  right50       = { x = 0.50, y = 0.00, w = 0.50, h = 1.00 },
  left50        = { x = 0.00, y = 0.00, w = 0.50, h = 1.00 },
  right40       = { x = 0.60, y = 0.00, w = 0.40, h = 1.00 },
  left60        = { x = 0.00, y = 0.00, w = 0.60, h = 1.00 },
  top50         = { x = 0.00, y = 0.00, w = 1.00, h = 0.50 },
  bot50         = { x = 0.00, y = 0.50, w = 1.00, h = 0.50 },
  maximum       = { x = 0.00, y = 0.00, w = 1.00, h = 1.00 }
}

hs.window.animationDuration = 0
mash = { 'option', 'ctrl', 'cmd' }
hs.hotkey.bind(mash, 'right', function() hs.window.focusedWindow():move(units.right50,    nil, true) end)
hs.hotkey.bind(mash, 'left', function() hs.window.focusedWindow():move(units.left50,     nil, true) end)
hs.hotkey.bind(mash, 'up', function() hs.window.focusedWindow():move(units.top50,      nil, true) end)
hs.hotkey.bind(mash, 'down', function() hs.window.focusedWindow():move(units.bot50,      nil, true) end)
hs.hotkey.bind(mash, 'm', function() hs.window.focusedWindow():move(units.maximum,    nil, true) end)
hs.hotkey.bind(mash, 'n', function() 
  -- Get the focused window, its window frame dimensions, its screen frame dimensions,
  -- and the next screen's frame dimensions.
  local focusedWindow = hs.window.focusedWindow()
  local focusedScreenFrame = focusedWindow:screen():frame()
  local nextScreenFrame = focusedWindow:screen():next():frame()
  local windowFrame = focusedWindow:frame()

  -- Calculate the coordinates of the window frame in the next screen and retain aspect ratio
  windowFrame.x = ((((windowFrame.x - focusedScreenFrame.x) / focusedScreenFrame.w) * nextScreenFrame.w) + nextScreenFrame.x)
  windowFrame.y = ((((windowFrame.y - focusedScreenFrame.y) / focusedScreenFrame.h) * nextScreenFrame.h) + nextScreenFrame.y)
  windowFrame.h = ((windowFrame.h / focusedScreenFrame.h) * nextScreenFrame.h)
  windowFrame.w = ((windowFrame.w / focusedScreenFrame.w) * nextScreenFrame.w)

  -- Set the focused window's new frame dimensions
  focusedWindow:setFrame(windowFrame)
end)

-- GOTCHA How to find an apps name
-- I had issues with figuring out Visual Studio Code's name (which was Code)
-- I found all the process id's for Visual Studio Code and tried the below until
-- app wasn't nil `ps -ef | grep Visual | grep -oE "\d+ \d+" | cut -d ' ' -f 2`
-- Example for process 11123
local app = hs.application.get("Warp")
print("app is: ", app)

layouts = {
  codeTerminal = {
    { name = 'Code', app = 'Visual Studio Code.app', unit = units.left50 },
    { name = 'Warp', app = 'Warp.app', unit = units.right50}
  },
  codeBrowser = {
    { name = 'Google Chrome', app = 'Google Chrome.app', unit = units.right50},
    { name = 'Code', app = 'Visual Studio Code.app', unit = units.left50 },
  },
  terminalBrowser = {
    { name = 'Google Chrome', app = 'Google Chrome.app', unit = units.right50},
    { name = 'Warp', app = 'Warp.app', unit = units.left50}
  },
  -- special mode to get the learn go with test sidebar disappear
  learnGoByTests = {
    { name = 'Google Chrome', app = 'Google Chrome.app', unit = units.right40},
    { name = 'Code', app = 'Visual Studio Code.app', unit = units.left60 },
  }
}

-- Takes a layout definition (e.g. 'layouts.work') and iterates through
-- each application definition, laying it out as speccified
function runLayout(layout)
  for i = 1,#layout do
    local t = layout[i]
    hs.application.open(t.app)
    local theapp = hs.application.get(t.name)
    local win = theapp:mainWindow()
    local screen = nil
    if t.screen ~= nil then
      screen = hs.screen.find(t.screen)
    end
    win:move(t.unit, screen, true)
  end
end


-------------------------------------------------------------------
-- Launcher
--
-- This is the awesome. The other stuff is all cool, but this is the
-- thing I love the most because it reduces the amount of time I
-- spend with the mouse, and is far more deterministic than trying
-- to use cmd+tab.
--
-- The idea here is to have a MODE-BASED app launching and app
-- switching system. Traditional Mac philosophy (and Emacs :D)
-- would have us contort our hands into crazy combinations of keys
-- to manipulate the state of the machine, which is a serious pain
-- in the ass. Using Hammerspoon we can avoid that.
--
-- * ctrl+space gets us into "launch mode"
-- * In "launch mode" the keyboard changes so that each key can now
--   have a new meaning. For example, the 'v' key is now responsible
--   for either launching or switching to VimR
-- * You can then map whatever you like to whatever function you'd
--   like to invoke.
--
-- It's just a big pile of awesome.
-------------------------------------------------------------------

-- We need to store the reference to the alert window
appLauncherAlertWindow = nil

-- This is the key mode handle
launchMode = hs.hotkey.modal.new({}, nil, '')

-- Leaves the launch mode, returning the keyboard to its normal
-- state, and closes the alert window, if it's showing
function leaveMode()
  if appLauncherAlertWindow ~= nil then
    hs.alert.closeSpecific(appLauncherAlertWindow, 0)
    appLauncherAlertWindow = nil
  end
  launchMode:exit()
end

-- So simple, so awesome.
function switchToApp(app)
  hs.application.open(app)
  leaveMode()
end

hs.hotkey.bind({ 'cmd'}, 'h', function() hs.application.open('Safari.app') end)
hs.hotkey.bind({ 'cmd'}, 'k', function() hs.application.open('Warp.app') end)
-- hs.hotkey.bind({ 'cmd'}, 'j', function() hs.application.open('Visual Studio Code - Insiders.app') end)
hs.hotkey.bind({ 'cmd'}, 'j', function() hs.application.open('Visual Studio Code.app') end)
hs.hotkey.bind({ 'cmd'}, 'g', function() hs.application.open('Slack.app') end)
hs.hotkey.bind({ 'cmd'}, 'y', function() hs.application.open('Polypane.app') end)

-- Enters launch mode. The bulk of this is geared toward
-- showing a big ugly window that can't be ignored; the
-- keyboard is now in launch mode.
-- hs.hotkey.bind({ 'cmd', 'shift' }, 'space', function()
--   launchMode:enter()
--   appLauncherAlertWindow = hs.alert.show('App Launcher Mode', {
--     strokeColor = hs.drawing.color.x11.black,
--     fillColor = hs.drawing.color.x11.white,
--     textColor = hs.drawing.color.x11.black,
--     strokeWidth = 20,
--     radius = 30,
--     textSize = 128,
--     fadeInDuration = 0,
--     atScreenEdge = 2
--   }, 'infinite')
-- end)

local openPolypaneCommandBarAppleScript = [[
tell application "System Events"
  tell process "Polypane"
		activate
		click menu item "Open Command bar" of menu "View" of menu bar 1
	end tell
end tell
]]
local polypaneKeybinding = hs.hotkey.new({'option'}, 'k', function()
  hs.osascript.applescript(openPolypaneCommandBarAppleScript);
  hs.application.open('Polypane.app');
end)
local polypaneWindowFilter = hs.window.filter.new('Polypane')
polypaneWindowFilter:subscribe(hs.window.filter.windowFocused, function()
  polypaneKeybinding:enable()
end)
polypaneWindowFilter:subscribe(hs.window.filter.windowUnfocused, function()
  polypaneKeybinding:disable()
end)

local toggleDarkModeAppleScript = [[
tell application "System Events"
  tell appearance preferences
    set dark mode to not dark mode
  end tell
end tell
]]

hs.hotkey.bind({ 'option'}, 'd', function()
  hs.osascript.applescript(toggleDarkModeAppleScript);
end)
hs.hotkey.bind({ 'option'}, 'p', function() switchToApp('Spotify.app') end)
hs.hotkey.bind({ 'option'}, 'm', function() switchToApp('Miro.app') end)
hs.hotkey.bind({ 'option'}, 'b', function() hs.screen'Dell':setMode(1920, 1080, 2.0, 60, 8.0) end)
hs.hotkey.bind({ 'option'}, 'n', function() hs.screen'Dell':setMode(2560, 1440, 2.0, 60, 8.0) end)
hs.hotkey.bind({ 'option'}, 'x', function() hs.screen'Dell':setMode(3008, 1692, 2.0, 60, 8.0) end)
hs.hotkey.bind({ 'option', 'shift'}, 'b', function() hs.screen'Retina':setMode(1024, 640, 2.0, 0.0, 4.0) end)
hs.hotkey.bind({ 'option', 'shift'}, 'n', function() hs.screen'Retina':setMode(1440, 900, 2.0, 0.0, 4.0) end)
hs.hotkey.bind({ 'option', 'shift'}, 'x', function() hs.screen'Retina':setMode(1680, 1050, 2.0, 0.0, 4.0) end)

-- When in launch mode, hitting ctrl+space again leaves it
launchMode:bind({ 'cmd', 'shift' }, 'space', function() leaveMode() end)

-- Mapped keys
launchMode:bind({}, 'a',  function() switchToApp('Simulator.app') end)
launchMode:bind({}, 'f',  function() switchToApp('Finder.app') end)
launchMode:bind({}, 'g',  function() switchToApp('Google Chrome.app') end)
launchMode:bind({}, 'r',  function() switchToApp('Safari') end)
launchMode:bind({}, 's',  function() switchToApp('Slack.app') end)
launchMode:bind({}, 'p',  function() switchToApp('Spotify.app') end)
launchMode:bind({}, 'v',  function() switchToApp('Visual Studio Code.app') end)
launchMode:bind({}, 'y',  function() switchToApp('Polypane.app') end)
launchMode:bind({}, 'm',  function() switchToApp('Messages.app') end)
launchMode:bind({}, 'x',  function() switchToApp('Xcode.app') end)
launchMode:bind({}, 'i',  function() switchToApp('Warp.app') end)
launchMode:bind({}, 'c',  function() runLayout(layouts.codeTerminal); leaveMode() end)
launchMode:bind({}, 'q',  function() runLayout(layouts.codeBrowser); leaveMode() end)
launchMode:bind({}, 'w',  function() runLayout(layouts.terminalBrowser); leaveMode() end)
launchMode:bind({}, 'l',  function() 
  hs.execute("/usr/local/bin/code ~/code/learn-go-by-tests/2/");
  hs.execute("open https://quii.gitbook.io/learn-go-with-tests/go-fundamentals/select");
  runLayout(layouts.learnGoByTests);
  leaveMode()
end)

launchMode:bind({}, '.',  function() hs.execute('open ~/.hammerspoon/init.lua'); leaveMode() end)
launchMode:bind({}, '`',  function() hs.reload(); leaveMode() end)

-- Unmapped keys
launchMode:bind({}, 'b',  function() leaveMode() end)
launchMode:bind({}, 'd',  function() leaveMode() end)
launchMode:bind({}, 'e',  function() leaveMode() end)
launchMode:bind({}, 'h',  function() leaveMode() end)
launchMode:bind({}, 'j',  function() leaveMode() end)
launchMode:bind({}, 'k',  function() leaveMode() end)
launchMode:bind({}, 'n',  function() leaveMode() end)
launchMode:bind({}, 'o',  function() leaveMode() end)
launchMode:bind({}, 'u',  function() leaveMode() end)
launchMode:bind({}, 'z',  function() leaveMode() end)
launchMode:bind({}, '1',  function() leaveMode() end)
launchMode:bind({}, '2',  function() leaveMode() end)
launchMode:bind({}, '3',  function() leaveMode() end)
launchMode:bind({}, '4',  function() leaveMode() end)
launchMode:bind({}, '5',  function() leaveMode() end)
launchMode:bind({}, '6',  function() leaveMode() end)
launchMode:bind({}, '7',  function() leaveMode() end)
launchMode:bind({}, '8',  function() leaveMode() end)
launchMode:bind({}, '9',  function() leaveMode() end)
launchMode:bind({}, '0',  function() leaveMode() end)
launchMode:bind({}, '-',  function() leaveMode() end)
launchMode:bind({}, '=',  function() leaveMode() end)
launchMode:bind({}, '[',  function() leaveMode() end)
launchMode:bind({}, ']',  function() leaveMode() end)
launchMode:bind({}, '\\', function() leaveMode() end)
launchMode:bind({}, ';',  function() leaveMode() end)
launchMode:bind({}, "'",  function() leaveMode() end)
launchMode:bind({}, ',',  function() leaveMode() end)
launchMode:bind({}, '/',  function() leaveMode() end)