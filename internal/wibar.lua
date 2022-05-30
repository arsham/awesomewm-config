local modkey = "Mod4"

local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
local wibox = require("wibox")
local beautiful = require("beautiful")
local lain = require("lain")
local widgets = require("internal.widgets")
local dpi = require("beautiful.xresources").apply_dpi
local naughty = require("naughty")
local vars = require("internal.variables")
naughty.config.defaults["icon_size"] = vars.theme.icon_size

awful.layout.suit.tile.left.mirror = true
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

-- Connection For Each Screen {{{
screen.connect_signal("request::desktop_decoration", function(s)
  set_wallpaper(s)
  -- Each screen has its own tag table.
  awful.tag(vars.tags, s, awful.layout.layouts[1])
  -- Create a promptbox for each screen
  s.mypromptbox = awful.widget.prompt()

  -- Layout indicator icon {{{
  -- which will contain an icon indicating which layout we're using. We need
  -- one layoutbox per screen.
  mylayoutbox = awful.widget.layoutbox(s)
  mylayoutbox:buttons(gears.table.join(
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

  mywibox = awful.wibar({
    position = vars.wibar.position,
    screen = s,
    height = vars.wibar.height,
  })

  local function with_margin(widget)
    return wibox.container.margin(widget, dpi(4), dpi(8), dpi(4), dpi(4))
  end

  -- Add widgets to the wibox {{{
  mywibox:setup({
    layout = wibox.layout.align.horizontal,
    {
      layout = wibox.layout.fixed.horizontal,
      taglist,
      with_margin(wibox.widget({
        widgets.netgraph(),
        widgets.netspeed(),
        layout = wibox.layout.stack,
      })),
      widgets.weather(),
      s.mypromptbox,
    },
    tasklist,
    {
      layout = wibox.layout.fixed.horizontal,
      with_margin(widgets.thermal_cpu()),
      with_margin(widgets.cpuwidget()),
      with_margin(widgets.fanwidget()),
      with_margin(widgets.thermal_gpu()),
      with_margin(widgets.memwidget()),
      require("internal.widgets.dropbox"),
      require("internal.widgets.battery"),
      wibox.widget.systray(),
      textclock(),
      mylayoutbox,
    },
  }) --}}}
end) -- }}}

-- vim: fdm=marker fdl=0
