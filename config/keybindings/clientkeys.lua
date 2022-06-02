-- Imports {{{
local gears = require("gears")
local awful = require("awful")
local lain = require("lain")
local gmath = require("gears.math")
local vars = require("config.variables")

local modkey = vars.keys.mod
local altkey = vars.keys.alt
local ctrlkey = vars.keys.ctrl
local shiftkey = vars.keys.shift
local leftkey = vars.keys.left
local rightkey = vars.keys.right
local upkey = vars.keys.up
local downkey = vars.keys.down
local esckey = vars.keys.esc
local returnkey = vars.keys.ret
--}}}

local function _opt(desc, group)
  return { description = desc, group = group }
end

local clientkeys = gears.table.join(
  awful.key({ modkey }, "q", function(c)
    c:kill()
  end, _opt("close", "client")),

  -- Moving {{{
  awful.key({ modkey, ctrlkey }, returnkey, function(c)
    c:swap(awful.client.getmaster())
  end, _opt("move to master", "client")),
  awful.key({ modkey }, "o", function(c)
    c:move_to_screen()
  end, _opt("move to screen", "client")),

  awful.key({ altkey, ctrlkey, shiftkey }, "h", function()
    local focused = client.focus
    if not focused then
      return
    end
    local curtag = focused.screen.selected_tag
    local tags = focused.screen.tags
    local idx = curtag.index
    local newtag = tags[gmath.cycle(#tags, idx - 1)]
    focused:move_to_tag(newtag)
    awful.tag.viewprev()
  end, _opt("move client to previous tag", "client")),

  awful.key({ altkey, ctrlkey, shiftkey }, "l", function()
    local focused = client.focus
    if not focused then
      return
    end
    local curtag = focused.screen.selected_tag
    local tags = focused.screen.tags
    local idx = curtag.index
    local newtag = tags[gmath.cycle(#tags, idx + 1)]
    focused:move_to_tag(newtag)
    awful.tag.viewnext()
  end, _opt("move client to next tag", "client")),

  awful.key({ altkey }, esckey, function()
    local c = awful.client.focus.history.list[2]
    client.focus = c
    local t = client.focus and client.focus.first_tag or nil
    if t then
      t:view_only()
    end
    c:raise()
  end, _opt("go back", "client")),
  --}}}

  -- Toggling {{{
  awful.key({ modkey }, "t", function(c)
    c.ontop = not c.ontop
  end, _opt("toggle keep on top", "client")),
  awful.key({ modkey }, "n", function(c)
    -- The client currently has the input focus, so it cannot be
    -- minimized, since minimized clients can't have the focus.
    c.minimized = true
  end, _opt("minimize", "client")),
  awful.key({ modkey, ctrlkey }, "n", function()
    local c = awful.client.restore()
    -- Focus restored client
    if c then
      c:emit_signal("request::activate", "key.unminimize", { raise = true })
      c:raise()
    end
  end, _opt("restore minimized", "client")),
  awful.key({ modkey }, "m", function(c)
    c.maximized = not c.maximized
    c:raise()
  end, _opt("(un)maximize", "client")),
  awful.key({ modkey, ctrlkey }, "h", function(c)
    c.maximized_vertical = not c.maximized_vertical
    c:raise()
  end, _opt("(un)maximize vertically", "client")),
  awful.key({ modkey, ctrlkey }, "v", function(c)
    c.maximized_horizontal = not c.maximized_horizontal
    c:raise()
  end, _opt("(un)maximize horizontally", "client")),

  awful.key({ altkey, shiftkey }, "m", lain.util.magnify_client, _opt("magnify client", "client")),
  awful.key({ modkey }, "F11", function(c)
    c.fullscreen = not c.fullscreen
    c:raise()
  end, _opt("toggle fullscreen", "client")),
  awful.key({ modkey }, "f", awful.client.floating.toggle, _opt("toggle floating", "client")),
  awful.key({ modkey, ctrlkey }, "s", function(c)
    c.sticky = not c.sticky
  end, _opt("toggle sticky", "client")),
  --}}}

  -- Resize windows {{{
  awful.key({ modkey, ctrlkey }, upkey, function(c)
    if c.floating then
      c:relative_move(0, 0, 0, -10)
    else
      awful.client.incwfact(0.025)
    end
  end, _opt("Floating Resize Vertical -", "client")),
  awful.key({ modkey, ctrlkey }, downkey, function(c)
    if c.floating then
      c:relative_move(0, 0, 0, 10)
    else
      awful.client.incwfact(-0.025)
    end
  end, _opt("Floating Resize Vertical +", "client")),
  awful.key({ modkey, ctrlkey }, leftkey, function(c)
    if c.floating then
      c:relative_move(0, 0, -10, 0)
    else
      awful.tag.incmwfact(-0.025)
    end
  end, _opt("Floating Resize Horizontal -", "client")),
  awful.key({ modkey, ctrlkey }, rightkey, function(c)
    if c.floating then
      c:relative_move(0, 0, 10, 0)
    else
      awful.tag.incmwfact(0.025)
    end
  end, _opt("Floating Resize Horizontal +", "client")),
  --}}}

  -- Moving floating windows {{{
  awful.key({ modkey, shiftkey }, downkey, function(c)
    c:relative_move(0, 10, 0, 0)
  end, _opt("Floating Move Down", "client")),
  awful.key({ modkey, shiftkey }, upkey, function(c)
    c:relative_move(0, -10, 0, 0)
  end, _opt("Floating Move Up", "client"))
  -- awful.key({ modkey, shiftkey }, leftkey, function(c)
  --   c:relative_move(-10, 0, 0, 0)
  -- end, _opt("Floating Move Left", "client")),
  -- awful.key({ modkey, shiftkey }, rightkey, function(c)
  --   c:relative_move(10, 0, 0, 0)
  -- end, _opt("Floating Move Right", "client"))
  --}}}
)

return clientkeys

-- vim: fdm=marker fdl=0
