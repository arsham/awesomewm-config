-- Importing Modules {{{
pcall(require, "luarocks.loader")

-- Standard awesome library
local awful = require("awful")
require("awful.autofocus")
require("awful.hotkeys_popup.keys")
local menubar = require("menubar")
local naughty = require("naughty")
local vars = require("config.variables")
local terminal = vars.apps.terminal
awful.util.terminal = terminal
menubar.utils.terminal = terminal
awful.util.shell = vars.apps.shell
--}}}

-- Error handling {{{
-- Handle runtime errors during startup.
if awesome.startup_errors then
  naughty.notify({
    preset = naughty.config.presets.critical,
    title = "Startup encountered a problem",
    text = awesome.startup_errors,
  })
end

naughty.connect_signal("request::display_error", function(message, startup)
  naughty.notification({
    urgency = "critical",
    title = "Oops, an error happened" .. (startup and " during startup!" or "!"),
    message = message,
  })
end)

-- Handle runtime errors after startup.
do
  local in_error = false
  awesome.connect_signal("debug::error", function(err)
    if in_error then
      return
    end
    in_error = true

    naughty.notify({
      preset = naughty.config.presets.critical,
      title = "Error",
      text = tostring(err),
    })
    in_error = false
  end)
end
-- }}}

require("theme.theme")
require("config.menu")
require("config.layouts")
require("config.wibar")
require("config.keybindings")
require("config.rules")
require("config.signals")
require("widgets.osd")
require("config.autoload")
require("config.naughty")

collectgarbage()
collectgarbage("setpause", 110)
collectgarbage("setstepmul", 1000)

-- vim: fdm=marker fdl=0
