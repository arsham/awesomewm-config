local awful = require("awful")
local ruled = require("ruled")

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

-- Normally we'd do this with a rule, but some program like spotify doesn't set
-- its class or name until after it starts up, so we need to catch that signal.
client.connect_signal("property::class", function(c) --{{{
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
end) --}}}

-- vim: fdm=marker fdl=0
