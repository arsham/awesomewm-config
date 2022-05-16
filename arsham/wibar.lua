local client, tag = client, tag
local modkey = "Mod4"

local gears = require("gears") --Utilities such as color parsing and objects
local awful = require("awful") --Everything related to window managment
require("awful.autofocus")
local wibox = require("wibox") -- Widget and layout library
local beautiful = require("beautiful") -- Theme handling library
local lain = require("lain")
local arsham = require("arsham.widgets")
local dpi = require("beautiful.xresources").apply_dpi
local naughty = require("naughty")

awful.util.tagnames = { "➊", "➋", "➌", "➍", "➎", "➏", "➐", "➑", "➒", "" }
awful.layout.suit.tile.left.mirror = true

naughty.config.defaults["icon_size"] = 100

tag.connect_signal("request::default_layouts", function()
  awful.layout.append_default_layouts({
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.magnifier,
    awful.layout.suit.floating,
    lain.layout.cascade,
    lain.layout.cascade.tile,
    lain.layout.centerwork,
    lain.layout.centerwork.horizontal,
    lain.layout.termfair,
    lain.layout.termfair.center,
  })
end)

-- Disable window snapping
awful.mouse.snap.edge_enabled = false

lain.layout.termfair.nmaster = 3
lain.layout.termfair.ncol = 1
lain.layout.termfair.center.nmaster = 3
lain.layout.termfair.center.ncol = 1
lain.layout.cascade.tile.offset_x = dpi(2)
lain.layout.cascade.tile.offset_y = dpi(32)
lain.layout.cascade.tile.extra_padding = dpi(5)
lain.layout.cascade.tile.nmaster = 5
lain.layout.cascade.tile.ncol = 2
-- }}}

-- Taglist Buttons {{{
local taglist_buttons = gears.table.join(
  awful.button({}, 1, function(t)
    t:view_only()
  end),
  awful.button({ modkey }, 1, function(t)
    if client.focus then
      client.focus:move_to_tag(t)
    end
  end),
  awful.button({}, 3, awful.tag.viewtoggle),
  awful.button({ modkey }, 3, function(t)
    if client.focus then
      client.focus:toggle_tag(t)
    end
  end),
  awful.button({}, 4, function(t)
    awful.tag.viewnext(t.screen)
  end),
  awful.button({}, 5, function(t)
    awful.tag.viewprev(t.screen)
  end)
) -- }}}

-- Tasklist Buttons {{{
local tasklist_buttons = gears.table.join(
  awful.button({}, 1, function(c)
    if c == client.focus then
      c.minimized = true
    else
      c:emit_signal("request::activate", "tasklist", { raise = true })
    end
  end),
  awful.button({}, 3, function()
    awful.menu.client_list({ theme = { width = 250 } })
  end),
  awful.button({}, 4, function()
    awful.client.focus.byidx(1)
  end),
  awful.button({}, 5, function()
    awful.client.focus.byidx(-1)
  end)
) --}}}

local function set_wallpaper(s) --{{{
  if beautiful.wallpaper then
    local wallpaper = beautiful.wallpaper
    -- If wallpaper is a function, call it with the screen
    if type(wallpaper) == "function" then
      wallpaper = wallpaper(s)
    end
    gears.wallpaper.maximized(wallpaper, s, true)
  end
end --}}}

local textclock = function()
  local widget = wibox.widget.textclock()
  lain.widget.cal({
    attach_to = { widget },
  })
  return widget
end

-- Keyboard map indicator and switcher
local mykeyboardlayout = awful.widget.keyboardlayout()

-- Connection For Each Screen {{{
awful.screen.connect_for_each_screen(function(s)
  set_wallpaper(s)

  -- Each screen has its own tag table.
  awful.tag(awful.util.tagnames, s, awful.layout.layouts[1])

  -- Create a promptbox for each screen
  s.mypromptbox = awful.widget.prompt()

  -- Layout indicator icon {{{
  -- which will contain an icon indicating which layout we're using. We need
  -- one layoutbox per screen.
  s.mylayoutbox = awful.widget.layoutbox(s)
  s.mylayoutbox:buttons(gears.table.join(
    awful.button({}, 1, function()
      awful.layout.inc(1)
    end),
    awful.button({}, 3, function()
      awful.layout.inc(-1)
    end),
    awful.button({}, 4, function()
      awful.layout.inc(1)
    end),
    awful.button({}, 5, function()
      awful.layout.inc(-1)
    end)
  )) --}}}

  -- Taglist widget {{{
  local taglist = awful.widget.taglist({
    screen = s,
    filter = awful.widget.taglist.filter.all,
    buttons = taglist_buttons,
  }) --}}}

  -- Tasklist widget {{{
  local tasklist = awful.widget.tasklist({
    screen = s,
    filter = awful.widget.tasklist.filter.currenttags,
    buttons = tasklist_buttons,
  }) --}}}

  s.mywibox = awful.wibar({ position = "top", screen = s, height = 55 })

  -- Add widgets to the wibox {{{
  s.mywibox:setup({
    layout = wibox.layout.align.horizontal,
    { -- Left widgets
      layout = wibox.layout.fixed.horizontal,
      taglist,
      arsham.net_down_speed,
      arsham.net_down_graph,
      arsham.net_up_speed,
      arsham.net_up_graph,
      s.mypromptbox,
    },
    tasklist, -- Middle widget
    { -- Right widgets
      layout = wibox.layout.fixed.horizontal,
      wibox.container.margin(arsham.cpuwidget, dpi(4), dpi(8), dpi(4), dpi(4)),
      wibox.container.margin(arsham.fanwidget, dpi(4), dpi(8), dpi(4), dpi(4)),
      wibox.container.margin(arsham.memwidget, dpi(4), dpi(8), dpi(4), dpi(4)),
      require("arsham.widgets.dropbox"),
      wibox.widget.systray(),
      textclock(),
      -- mykeyboardlayout,
      s.mylayoutbox,
    },
  }) --}}}
  -- require("arsham.dropbox")
end) -- }}}
