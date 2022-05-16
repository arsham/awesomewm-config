local keys = require("arsham.keybindings")
local awful = require("awful") --Everything related to window managment
require("awful.autofocus")
local beautiful = require("beautiful") -- Theme handling library

-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
  -- All clients will match this rule {{{
  {
    rule = {},
    properties = {
      border_width = beautiful.border_width,
      border_color = beautiful.border_normal,
      focus = awful.client.focus.filter,
      raise = true,
      keys = keys.clientkeys,
      buttons = keys.clientbuttons,
      screen = awful.screen.preferred,
      placement = awful.placement.no_overlap + awful.placement.no_offscreen,
    },
  }, --}}}

  -- Floating clients {{{
  {
    rule_any = {
      instance = {
        "DTA", -- Firefox addon DownThemAll.
        "copyq", -- Includes session name in class.
        "pinentry",
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
        "archlinux-logout",
        "pinentry",
        "veromix",
        "xtightvncviewer",
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
      },
    },
    properties = { floating = true },
  }, --}}}

  -- Disabling titlebars{{{
  {
    rule_any = { type = { "normal", "dialog" } },
    properties = { titlebars_enabled = false },
  }, --}}}

  -- Program Rules {{{
  {
    rule = { class = "Gimp*", role = "gimp-image-window" },
    properties = { maximized = true },
  },
  { rule = { class = "Vlc" }, properties = { maximized = true } },
  { rule = { class = "VirtualBox Manager" }, properties = { maximized = true } },
  { rule = { class = "VirtualBox Machine" }, properties = { maximized = true } },
  { rule = { class = "Xfce4-settings-manager" }, properties = { floating = false } },
  { rule = { class = "[sS]lack" }, properties = { tag = awful.screen.focused().tags[10] } },

  -- Set Firefox to always map on the tag named "2" on screen 1.
  -- { rule = { class = "Firefox" },
  --   properties = { screen = 1, tag = "2" } },
  --}}}

  -- Floating clients but centered in screen{{{
  {
    rule_any = {
      class = {
        "Polkit-gnome-authentication-agent-1",
        "Arcolinux-calamares-tool.py",
      },
    },
    properties = { floating = true },
    callback = function(c)
      awful.placement.centered(c, nil)
    end,
  }, --}}}
}
