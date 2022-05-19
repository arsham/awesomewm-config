local keys = require("internal.keybindings")
local awful = require("awful")
local ruled = require("ruled")
require("awful.autofocus")
local beautiful = require("beautiful")

ruled.client.connect_signal("request::rules", function()
  -- All clients will match this rule.{{{
  ruled.client.append_rule({
    id = "global",
    rule = {},
    properties = {
      above = false,
      below = false,
      border_color = beautiful.border_normal,
      border_width = beautiful.border_width,
      buttons = keys.clientbuttons,
      floating = false,
      focus = awful.client.focus.filter,
      keys = keys.clientkeys,
      maximized = false,
      maximized_horizontal = false,
      maximized_vertical = false,
      ontop = false,
      placement = awful.placement.no_overlap + awful.placement.no_offscreen,
      raise = true,
      screen = awful.screen.preferred,
      sticky = false,
    },
  }) --}}}

  -- Disabling titlebars {{{
  ruled.client.append_rule({
    id = "titlebar_disabled",
    rule_any = { type = { "normal", "dialog" } },
    properties = { titlebars_enabled = false },
  }) --}}}

  -- Floating clients {{{
  ruled.client.append_rule({
    id = "floating_clients",
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
  }) --}}}

  -- Rounded corners {{{
  ruled.client.append_rule({
    id = "round_clients",
    rule_any = {
      type = {
        "normal",
        "dialog",
      },
    },
    except_any = {
      name = { "Discord Updater" },
    },
    properties = {
      round_corners = true,
      shape = beautiful.client_shape_rounded,
    },
  }) --}}}

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
      placement = awful.placement.centered,
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
      placement = awful.placement.centered,
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

  -- Terminal emulators {{{
  ruled.client.append_rule({
    id = "terminals",
    rule_any = {
      class = {
        "URxvt",
        "XTerm",
        "UXTerm",
        "kitty",
        "K3rmit",
      },
    },
    properties = {
      tag = "1",
      switch_to_tags = true,
      size_hints_honor = false,
    },
  }) --}}}

  -- Browsers and chats {{{
  ruled.client.append_rule({
    id = "internet",
    rule_any = {
      class = {
        "Brave-browser",
        "firefox",
        "Tor Browser",
        "discord",
        "Chromium",
        "Google-chrome",
      },
    },
  })

  ruled.client.append_rule({
    id = "hidden",
    rule_any = {
      name = {
        "meet.google.com is sharing your screen.",
      },
    },
    properties = { hidden = true },
  })
  --}}}

  -- Text editors and word processing {{{
  ruled.client.append_rule({
    id = "text",
    rule_any = {
      class = {
        "Subl3",
      },
      name = {
        "LibreOffice",
        "libreoffice",
      },
    },
  }) --}}}

  -- File managers {{{
  ruled.client.append_rule({
    id = "files",
    rule_any = {
      class = {
        "pcmanfm",
        "dolphin",
        "ark",
        "Nemo",
        "File-roller",
      },
    },
  }) --}}}

  -- Multimedia {{{
  ruled.client.append_rule({
    id = "multimedia",
    rule_any = {
      class = {
        "vlc",
        "Spotify",
      },
    },
    properties = {
      placement = awful.placement.centered,
      maximized = true,
    },
  }) --}}}

  -- Gaming {{{
  ruled.client.append_rule({
    id = "gaming",
    rule_any = {
      class = {
        "Wine",
        "dolphin-emu",
        "Steam",
        "Citra",
        "supertuxkart",
      },
      name = { "Steam" },
    },
    properties = {
      skip_decoration = true,
      placement = awful.placement.centered,
    },
  }) --}}}

  -- Multimedia Editing {{{
  ruled.client.append_rule({
    id = "graphics",
    rule_any = {
      class = {
        "Gimp*",
        "Inkscape",
        "Flowblade",
      },
    },
    properties = { maximized = true },
  }) --}}}

  -- Sandboxes and VMs {{{
  ruled.client.append_rule({
    id = "sandbox",
    rule_any = {
      class = {
        "VirtualBox Manage",
        "VirtualBox Machine",
        "Gnome-boxes",
        "Virt-manager",
      },
    },
    properties = {
      tag = "8",
    },
  }) --}}}

  --- Slack {{{
  ruled.client.append_rule({
    id = "slack",
    rule = { class = "[sS]lack" },
    properties = { tag = awful.screen.focused().tags[9] },
  }) --}}}

  -- Image viewers {{{
  ruled.client.append_rule({
    id = "image_viewers",
    rule_any = {
      class = {
        "feh",
        "Pqiv",
        "Sxiv",
      },
    },
    properties = {
      skip_decoration = true,
      floating = true,
      ontop = true,
      placement = awful.placement.centered,
    },
  }) --}}}

  -- Floating {{{
  ruled.client.append_rule({
    id = "floating",
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
      },
      role = {
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
end)

-- Normally we'd do this with a rule, but some program like spotify doesn't set
-- its class or name until after it starts up, so we need to catch that signal.
client.connect_signal("property::class", function(c)
  if c.class == "Spotify" then
    local window_mode = false

    -- Check if fullscreen or window mode
    if c.fullscreen then
      window_mode = false
      c.fullscreen = false
    else
      window_mode = true
    end

    -- Check if Spotify is already open
    local app = function(cc)
      return ruled.client.match(cc, { class = "Spotify" })
    end

    local app_count = 0
    for _ in awful.client.iterate(app) do
      app_count = app_count + 1
    end

    -- If Spotify is already open, don't open a new instance
    if app_count > 1 then
      c:kill()
      -- Switch to previous instance
      for _ in awful.client.iterate(app) do
        c:jump_to(false)
      end
    else
      -- Move the instance to specified tag on this screen
      local t = awful.tag.find_by_name(awful.screen.focused(), "5")
      c:move_to_tag(t)
      t:view_only()

      -- Fullscreen mode if not window mode
      if not window_mode then
        c.fullscreen = true
      else
        c.floating = true
        awful.placement.centered(c, { honor_workarea = true })
      end
    end
  end
end)

-- vim: fdm=marker fdl=0
