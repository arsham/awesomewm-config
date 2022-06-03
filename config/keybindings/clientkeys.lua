-- Imports {{{
local gears = require("gears")
local awful = require("awful")
local lain = require("lain")
local vars = require("config.variables")

local modkey = vars.keys.mod
local ctrlkey = vars.keys.ctrl
local shiftkey = vars.keys.shift
local leftkey = vars.keys.left
local rightkey = vars.keys.right
local upkey = vars.keys.up
local downkey = vars.keys.down
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
  end, _opt("move to master", "move")),
  awful.key({ modkey }, "o", function(c)
    c:move_to_screen()
  end, _opt("move to screen", "move")),
  --}}}

  -- Toggling {{{
  awful.key({ modkey, ctrlkey }, "t", function(c)
    c.ontop = not c.ontop
  end, _opt("toggle keep on top", "toggle")),
  awful.key({ modkey, ctrlkey }, "m", function(c)
    c.maximized = not c.maximized
    c:raise()
  end, _opt("(un)maximize", "toggle")),

  awful.key({ modkey, shiftkey }, "m", lain.util.magnify_client, _opt("magnify client", "client")),
  awful.key({ modkey }, "F11", function(c)
    c.fullscreen = not c.fullscreen
    c:raise()
  end, _opt("toggle fullscreen", "toggle")),
  awful.key(
    { modkey, ctrlkey },
    "f",
    awful.client.floating.toggle,
    _opt("toggle floating", "toggle")
  ),
  awful.key({ modkey, ctrlkey }, "s", function(c)
    c.sticky = not c.sticky
  end, _opt("toggle sticky", "toggle")),
  --}}}

  -- Resize windows {{{
  awful.key({ modkey, ctrlkey }, upkey, function(c)
    if c.floating then
      c:relative_move(0, 0, 0, -10)
    else
      awful.client.incwfact(0.025)
    end
  end, _opt("Floating Resize Vertical -", "floating")),
  awful.key({ modkey, ctrlkey }, downkey, function(c)
    if c.floating then
      c:relative_move(0, 0, 0, 10)
    else
      awful.client.incwfact(-0.025)
    end
  end, _opt("Floating Resize Vertical +", "floating")),
  awful.key({ modkey, ctrlkey }, leftkey, function(c)
    if c.floating then
      c:relative_move(0, 0, -10, 0)
    else
      awful.tag.incmwfact(-0.025)
    end
  end, _opt("Floating Resize Horizontal -", "floating")),
  awful.key({ modkey, ctrlkey }, rightkey, function(c)
    if c.floating then
      c:relative_move(0, 0, 10, 0)
    else
      awful.tag.incmwfact(0.025)
    end
  end, _opt("Floating Resize Horizontal +", "floating")),
  --}}}

  -- Moving floating windows {{{
  awful.key({ modkey, shiftkey }, downkey, function(c)
    c:relative_move(0, 10, 0, 0)
  end, _opt("Floating Move Down", "floating")),
  awful.key({ modkey, shiftkey }, upkey, function(c)
    c:relative_move(0, -10, 0, 0)
  end, _opt("Floating Move Up", "floating")),
  awful.key({ modkey, shiftkey }, leftkey, function(c)
    c:relative_move(-10, 0, 0, 0)
  end, _opt("Floating Move Left", "floating")),
  awful.key({ modkey, shiftkey }, rightkey, function(c)
    c:relative_move(10, 0, 0, 0)
  end, _opt("Floating Move Right", "floating"))
  -- }}}
)

return clientkeys

-- vim: fdm=marker fdl=0
