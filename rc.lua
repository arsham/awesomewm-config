-- vim: fdm=marker fdl=0

-- Importing Modules {{{
local awesome, root = awesome, root
pcall(require, "luarocks.loader")

-- Standard awesome library
local awful = require("awful")
require("awful.autofocus")
require("awful.hotkeys_popup.keys")
local menubar = require("menubar")

local terminal = "kitty"
awful.util.terminal = terminal
menubar.utils.terminal = terminal
awful.util.shell = "zsh"

local beautiful = require("beautiful")
local naughty = require("naughty")
--}}}

-- Error handling {{{
-- Handle runtime errors during startup.
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
    -- Make sure we don't go into an endless error loop
    if in_error then
      return
    end
    in_error = true

    naughty.notify({
      preset = naughty.config.presets.critical,
      title = "Oops, an error happened!",
      text = tostring(err),
    })
    in_error = false
  end)
end
-- }}}

beautiful.init(require("theme.theme"))
require("arsham.menu")
require("arsham.wibar")
root.keys(require("arsham.keybindings").globalkeys)
require("arsham.rules")
require("arsham.signals")
require("arsham.autoload")
