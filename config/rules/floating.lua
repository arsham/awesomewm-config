local keys = require("config.keybindings")
local placement = require("lib.placement")
local awful = require("awful")
local ruled = require("ruled")

-- Floating clients {{{
ruled.client.append_rule({
  id = "floating_clients",
  rule_any = {
    instance = {
      "DTA", -- Firefox addon DownThemAll.
      "copyq", -- Includes session name in class.
      "pinentry",
      "Devtools", -- Firefox devtools
    },
    class = {
      "Arandr",
      "Arcolinux-welcome-app.py",
      "Blueberry",
      "Blueman-manager",
      "Font-manager",
      "Galculator",
      "Gnome-font-viewer",
      "Gpick",
      "Imagewriter",
      "Kruler",
      "MessageWin", -- kalarm.
      "Peek",
      "Skype",
      "Sxiv",
      "System-config-printer.py",
      "Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
      "Unetbootin.elf",
      "Wpa_gui",
      "Xfce4-terminal",
      "pinentry",
      "veromix",
      "xtightvncviewer",
      "Gnome-screenshot",
    },

    -- Note that the name property shown in xprop might be set slightly after creation of the client
    -- and the name shown there might not match defined rules here.
    name = {
      "Event Tester", -- xev.
    },
    role = {
      "AlarmWindow", -- Thunderbird's calendar.
      "ConfigManager", -- Thunderbird's about:config.
      "pop-up", -- e.g. Google Chrome's (detached) Developer Tools.
      "Preferences",
      "setup",
      "GtkFileChooserDialog",
      "conversation",
    },
    type = {
      "dialog",
    },
  },
  properties = { floating = true, placement = placement.centered },
}) --}}}

-- Floating On Top {{{
ruled.client.append_rule({
  id = "floating_on_top",
  rule_any = {
    instance = {
      "file_progress",
      "Popup",
      "nm-connection-editor",
    },
    class = {
      "scrcpy",
      "Mugshot",
      "Pulseeffects",
      "Gcolor2",
    },
    role = {
      "AlarmWindow",
      "ConfigManager",
      "pop-up",
    },
    name = {
      "Picture-in-Picture",
    },
  },
  properties = {
    skip_decoration = true,
    ontop = true,
    floating = true,
    focus = awful.client.focus.filter,
    raise = true,
    keys = keys.clientkeys,
    buttons = keys.clientbuttons,
    placement = awful.placement.centered,
  },
}) -- }}}

-- Dialogs {{{
ruled.client.append_rule({
  id = "dialog",
  rule_any = {
    type = { "dialog" },
    class = { "calendar.google.com" },
  },
  properties = {
    floating = true,
    above = true,
    skip_decoration = true,
    placement = placement.centered,
  },
}) --}}}

-- Modals{{{
ruled.client.append_rule({
  id = "modal",
  rule_any = {
    type = { "modal" },
  },
  properties = {
    floating = true,
    above = true,
    skip_decoration = true,
    placement = placement.centered,
  },
}) --}}}

-- Utilities {{{
ruled.client.append_rule({
  id = "utility",
  rule_any = {
    type = { "utility" },
  },
  properties = {
    floating = true,
    skip_decoration = true,
    placement = awful.placement.centered,
  },
}) --}}}

-- Splash {{{
ruled.client.append_rule({
  id = "splash",
  rule_any = {
    type = { "splash" },
    name = { "Discord Updater" },
  },
  properties = {
    titlebars_enabled = false,
    round_corners = false,
    floating = true,
    above = true,
    skip_decoration = true,
    placement = awful.placement.centered,
  },
}) --}}}

-- Disabled {{{
ruled.client.append_rule({
  id = "disabled",
  rule_any = {
    type = {
      "AlarmWindow",
      "ConfigManager",
      "pop-up",
    },
  },
  properties = {
    skip_decoration = true,
    ontop = true,
    floating = true,
    focus = awful.client.focus.filter,
    raise = true,
    keys = keys.clientkeys,
    buttons = keys.clientbuttons,
    placement = awful.placement.centered,
  },
}) --}}}

-- Fullscreen {{{
ruled.client.append_rule({
  id = "fullscreen",
  rule_any = {
    class = {
      "archlinux-logout",
    },
  },
  properties = {
    fullscreen = true,
    titlebars_enabled = false,
    round_corners = false,
    floating = true,
    above = true,
    skip_decoration = true,
    placement = awful.placement.centered,
  },
}) --}}}

-- vim: fdm=marker fdl=0
