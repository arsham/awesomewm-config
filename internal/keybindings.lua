-- vim: fdm=marker fdl=1
-- Imports {{{2
local vars = require("internal.variables")

local terminal = vars.apps.terminal
local filemanager = vars.apps.filemanager
local browser = vars.apps.browser

local modkey = vars.keys.mod
local altkey = vars.keys.alt
local ctrlkey = vars.keys.ctrl
local shiftkey = vars.keys.shift
local leftkey = vars.keys.left
local rightkey = vars.keys.right
local escK = vars.keys.esc
local returnkey = vars.keys.ret
local spacekey = vars.keys.space
local tabkey = vars.keys.tab

local gears = require("gears") --Utilities such as color parsing and objects
local awful = require("awful") --Everything related to window managment
require("awful.autofocus")
local beautiful = require("beautiful") -- Theme handling library
local menubar = require("menubar")
local lain = require("lain")
--}}}

local function _opt(desc, group)
  return { description = desc, group = group }
end

-- Global Keys {{{
local globalkeys = gears.table.join(
  -- Core {{{
  awful.key({ modkey, shiftkey }, "q", awesome.quit, _opt("quit awesome", "awesome")),

  -- awful.key({ modkey }, "s", hotkeys_popup.show_help, _opt("show help", "awesome")),
  awful.key({ modkey, shiftkey }, "r", awesome.restart, _opt("reload awesome", "awesome")),
  awful.key({ modkey }, "w", function()
    awful.util.mymainmenu:show()
  end, _opt("show main menu", "awesome")),
  --}}}

  -- Tags {{{
  awful.key({ modkey }, escK, awful.tag.history.restore, _opt("go back", "tag")),
  awful.key({ modkey }, "h", awful.tag.viewprev, _opt("view previous", "tag")),
  awful.key({ modkey }, "l", awful.tag.viewnext, _opt("view next", "tag")),
  awful.key({ ctrlkey, altkey }, leftkey, awful.tag.viewprev, _opt("view previous", "tag")),
  awful.key({ ctrlkey, altkey }, rightkey, awful.tag.viewnext, _opt("view next", "tag")),

  -- awful.key({ modkey }, tabkey, awful.tag.viewnext, _opt("view next", "tag")),
  -- awful.key({ modkey, shiftkey }, tabkey, awful.tag.viewprev, _opt("view previous", "tag")),
  awful.key({ modkey }, tabkey, function()
    awful.spawn.with_shell("rofi -show window -modi window ")
  end, { description = "swap with next client by index", group = "client" }),

  awful.key({ modkey, shiftkey }, "n", lain.util.add_tag, _opt("add tag", "tag")),
  awful.key({ modkey, shiftkey }, "e", lain.util.rename_tag, _opt("rename tag", "tag")),
  awful.key({ modkey, shiftkey }, leftkey, function()
    lain.util.move_tag(-1)
  end, _opt("move tag left", "tag")),
  awful.key({ modkey, shiftkey }, rightkey, function()
    lain.util.move_tag(1)
  end, _opt("move tag right", "tag")),
  awful.key({ modkey, shiftkey }, "d", lain.util.delete_tag, _opt("delete tag", "tag")),
  --}}}

  -- Jump, focus and Swap {{{
  awful.key({ modkey, shiftkey }, "j", function()
    awful.client.swap.byidx(1)
  end, _opt("swap with next client by index", "client")),
  awful.key({ modkey, shiftkey }, "k", function()
    awful.client.swap.byidx(-1)
  end, _opt("swap with previous client by index", "client")),
  awful.key({ modkey }, "u", awful.client.urgent.jumpto, _opt("jump to urgent client", "client")),

  awful.key({ altkey }, tabkey, function()
    -- awful.client.focus.history.previous()
    -- if client.focus then
    --   client.focus:raise()
    -- end
    -- end, _opt("go back", "client")),
    awful.client.focus.byidx(1)
  end, _opt("focus next by index", "client")),

  awful.key({ modkey }, "j", function()
    awful.client.focus.byidx(1)
  end, _opt("focus next by index", "client")),
  awful.key({ modkey }, "k", function()
    awful.client.focus.byidx(-1)
  end, _opt("focus previous by index", "client")),

  awful.key({ modkey, ctrlkey }, "j", function()
    awful.screen.focus_relative(1)
  end, _opt("focus the next screen", "screen")),
  awful.key({ modkey, ctrlkey }, "k", function()
    awful.screen.focus_relative(-1)
  end, _opt("focus the previous screen", "screen")),
  --}}}

  -- Layout {{{
  awful.key({ modkey }, rightkey, function()
    awful.tag.incmwfact(0.05)
  end, _opt("increase master width factor", "layout")),
  awful.key({ modkey }, leftkey, function()
    awful.tag.incmwfact(-0.05)
  end, _opt("decrease master width factor", "layout")),
  awful.key({ modkey, shiftkey }, "h", function()
    awful.tag.incnmaster(1, nil, true)
  end, _opt("increase the number of master clients", "layout")),
  awful.key({ modkey, shiftkey }, "l", function()
    awful.tag.incnmaster(-1, nil, true)
  end, _opt("decrease the number of master clients", "layout")),
  awful.key({ modkey, ctrlkey }, "h", function()
    awful.tag.incncol(1, nil, true)
  end, _opt("increase the number of columns", "layout")),
  awful.key({ modkey, ctrlkey }, "l", function()
    awful.tag.incncol(-1, nil, true)
  end, _opt("decrease the number of columns", "layout")),
  awful.key({ modkey }, spacekey, function()
    awful.layout.inc(1)
  end, _opt("select next", "layout")),
  awful.key({ modkey, shiftkey }, spacekey, function()
    awful.layout.inc(-1)
  end, _opt("select previous", "layout")),

  awful.key({ altkey, ctrlkey }, "j", function()
    lain.util.useless_gaps_resize(5)
  end, _opt("increment useless gaps", "layout")),
  awful.key({ altkey, ctrlkey }, "k", function()
    lain.util.useless_gaps_resize(-5)
  end, _opt("decrement useless gaps", "layout")),
  --}}}

  -- Program Launchers {{{
  awful.key({ modkey }, returnkey, function()
    awful.spawn(terminal)
  end, _opt("open a terminal", "launcher")),
  awful.key({ modkey }, "b", function()
    awful.spawn(browser)
  end, _opt(browser, "launcher")),
  awful.key({ modkey }, "e", function()
    awful.util.spawn(filemanager)
  end, _opt(filemanager, "launcher")),

  awful.key({ altkey }, spacekey, function()
    awful.spawn(
      string.format(
        "rofi -show combi",
        beautiful.bg_normal,
        beautiful.fg_normal,
        beautiful.bg_focus,
        beautiful.fg_focus
      )
    )
  end, _opt("show dmenu", "launcher")),

  awful.key({ modkey }, "x", function()
    awful.prompt.run({
      prompt = "Run Lua code: ",
      textbox = awful.screen.focused().mypromptbox.widget,
      exe_callback = awful.util.eval,
      history_path = awful.util.get_cache_dir() .. "/history_eval",
    })
  end, _opt("lua execute prompt", "launcher")),

  awful.key({ modkey }, "p", function()
    menubar.show()
  end, _opt("show the menubar", "launcher")),

  awful.key({ modkey }, "c", function()
    awful.spawn.with_shell("rofi -show calc -modi calc -no-show-match -no-sort")
  end, { description = "show calculator", group = "launcher" }),

  --}}}

  -- Session management {{{
  awful.key({ ctrlkey, altkey }, "l", function()
    awful.util.spawn("archlinux-logout")
  end, _opt("lock screen", "system")),

  -- awful.key({ modkey }, escK, function()
  --   awful.util.spawn("xkill")
  -- end, _opt("Kill proces", "system")),
  -- }}}

  -- Audio {{{
  awful.key({ modkey }, "v", function()
    awful.util.spawn("pavucontrol")
  end, _opt("pulseaudio control", "system")),
  awful.key({}, "XF86AudioRaiseVolume", function()
    -- os.execute(string.format("amixer -q set %s 1%%+", beautiful.volume.channel))
    -- beautiful.volume.update()
    os.execute(string.format("amixer -q set %s 1%%+", "Master"))
    awesome.emit_signal("widget::volume")
    awesome.emit_signal("module::volume_osd:show", true)
  end),
  awful.key({}, "XF86AudioLowerVolume", function()
    -- os.execute(string.format("amixer -q set %s 1%%-", beautiful.volume.channel))
    -- beautiful.volume.update()
    os.execute(string.format("amixer -q set %s 1%%-", "Master"))
    awesome.emit_signal("widget::volume")
    awesome.emit_signal("module::volume_osd:show", true)
  end),
  awful.key({}, "XF86AudioMute", function()
    -- os.execute(
    --   string.format(
    --     "amixer -q set %s toggle",
    --     beautiful.volume.togglechannel or beautiful.volume.channel
    --   )
    -- )
    -- beautiful.volume.update()
    os.execute("amixer -q set Master toggle")
  end),
  awful.key({ ctrlkey, shiftkey }, "m", function()
    os.execute(string.format("amixer -q set %s 100%%", beautiful.volume.channel))
    beautiful.volume.update()
  end),
  awful.key({ ctrlkey, shiftkey }, "0", function()
    os.execute(string.format("amixer -q set %s 0%%", beautiful.volume.channel))
    beautiful.volume.update()
  end),

  --Media keys supported by mpd.
  awful.key({}, "XF86AudioPlay", function()
    awful.util.spawn("mpc toggle")
  end),
  awful.key({}, "XF86AudioNext", function()
    awful.util.spawn("mpc next")
  end),
  awful.key({}, "XF86AudioPrev", function()
    awful.util.spawn("mpc prev")
  end),
  awful.key({}, "XF86AudioStop", function()
    awful.util.spawn("mpc stop")
  end),
  --}}}

  -- Brightness{{{
  awful.key({}, "XF86MonBrightnessUp", function()
    os.execute("brightnessctl -q s +5%")
    awesome.emit_signal("widget::brightness")
    awesome.emit_signal("module::brightness_osd:show", true)
  end, _opt("+10%", "system")),
  awful.key({}, "XF86MonBrightnessDown", function()
    os.execute("brightnessctl -q s 5%-")
    awesome.emit_signal("widget::brightness")
    awesome.emit_signal("module::brightness_osd:show", true)
  end, _opt("-10%", "system"))
  --}}}
)
--}}}

-- Client Keys {{{
local clientkeys = gears.table.join(
  awful.key({ modkey }, "q", function(c)
    c:kill()
  end, _opt("close", "client")),

  awful.key({ modkey, ctrlkey }, returnkey, function(c)
    c:swap(awful.client.getmaster())
  end, _opt("move to master", "client")),
  awful.key({ modkey }, "o", function(c)
    c:move_to_screen()
  end, _opt("move to screen", "client")),

  -- Toggling {{{
  awful.key({ modkey, ctrlkey }, "t", function(c)
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
      -- c:raise()
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
  awful.key(
    { modkey, ctrlkey },
    "f",
    awful.client.floating.toggle,
    _opt("toggle floating", "client")
  ),
  awful.key({ modkey, ctrlkey }, "s", function(c)
    c.sticky = not c.sticky
  end, _opt("toggle sticky", "client")),
  --}}}

  -- Resize windows {{{
  awful.key({ modkey, ctrlkey }, "Up", function(c)
    if c.floating then
      c:relative_move(0, 0, 0, -10)
    else
      awful.client.incwfact(0.025)
    end
  end, _opt("Floating Resize Vertical -", "client")),
  awful.key({ modkey, ctrlkey }, "Down", function(c)
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
  awful.key({ modkey, shiftkey }, "Down", function(c)
    c:relative_move(0, 10, 0, 0)
  end, _opt("Floating Move Down", "client")),
  awful.key({ modkey, shiftkey }, "Up", function(c)
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
--}}}

-- Bind all key numbers to tags {{{
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
  globalkeys = gears.table.join(
    globalkeys,
    -- View tag only {{{
    awful.key({ modkey }, "#" .. i + 9, function()
      local focused = awful.screen.focused()
      local cur_tag = focused.tags[i]
      if cur_tag then
        cur_tag:view_only()
      end
    end, _opt("view tag #" .. i, "tag")),
    --}}}
    -- Toggle tag display {{{
    awful.key({ modkey, ctrlkey }, "#" .. i + 9, function()
      local focused = awful.screen.focused()
      local cur_tag = focused.tags[i]
      if cur_tag then
        awful.tag.viewtoggle(cur_tag)
      end
    end, _opt("toggle tag #" .. i, "tag")),
    --}}}
    -- Move client to tag {{{
    awful.key({ modkey, shiftkey }, "#" .. i + 9, function()
      if client.focus then
        local cur_tag = client.focus.screen.tags[i]
        if cur_tag then
          client.focus:move_to_tag(cur_tag)
        end
      end
    end, _opt("move focused client to tag #" .. i, "tag")),
    --}}}
    -- Toggle tag on focused client {{{
    awful.key({ modkey, ctrlkey, shiftkey }, "#" .. i + 9, function()
      if client.focus then
        local cur_tag = client.focus.screen.tags[i]
        if cur_tag then
          client.focus:toggle_tag(cur_tag)
        end
      end
    end, _opt("toggle focused client on tag #" .. i, "tag"))
    --}}}
  )
end
--}}}

-- Client Buttons {{{
local clientbuttons = gears.table.join(
  awful.button({}, 1, function(c)
    c:emit_signal("request::activate", "mouse_click", { raise = true })
  end),
  awful.button({ modkey }, 1, function(c)
    c:emit_signal("request::activate", "mouse_click", { raise = true })
    awful.mouse.client.move(c)
  end),
  awful.button({ modkey }, 3, function(c)
    c:emit_signal("request::activate", "mouse_click", { raise = true })
    awful.mouse.client.resize(c)
  end)
)
--}}}

return {
  globalkeys = globalkeys,
  clientbuttons = clientbuttons,
  clientkeys = clientkeys,
}
