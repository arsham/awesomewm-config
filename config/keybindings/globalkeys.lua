-- Imports {{{
local vars = require("config.variables")

local terminal = vars.apps.terminal
local aux_terminal = vars.apps.aux_terminal
local filemanager = vars.apps.filemanager
local browser = vars.apps.browser

local modkey = vars.keys.mod
local altkey = vars.keys.alt
local ctrlkey = vars.keys.ctrl
local shiftkey = vars.keys.shift
local leftkey = vars.keys.left
local rightkey = vars.keys.right
local esckey = vars.keys.esc
local returnkey = vars.keys.ret
local spacekey = vars.keys.space
local tabkey = vars.keys.tab

local gmath = require("gears.math")
local awful = require("awful")
local beautiful = require("beautiful")
local menubar = require("menubar")
local lain = require("lain")
local gtable = require("gears.table")
--}}}

-- Local Functions {{{
local function _opt(desc, group)
  return { description = desc, group = group }
end

local next_value = vars.extra_tags[1]
local function next_random_icon()
  next_value = gtable.cycle_value(vars.extra_tags, next_value)
  return next_value
end

local function nilfn() end
--}}}

-- Core {{{
awful.keyboard.append_global_keybindings({
  awful.key({ modkey, shiftkey }, "q", awesome.quit, _opt("quit awesome", "awesome")),
  awful.key({ modkey, shiftkey }, "r", awesome.restart, _opt("reload awesome", "awesome")),
  awful.key({ modkey }, "w", function()
    awful.util.mymainmenu:show()
  end, _opt("show main menu", "awesome")),
}) --}}}

-- Tags {{{
awful.keyboard.append_global_keybindings({
  awful.key({ modkey }, esckey, awful.tag.history.restore, _opt("go back", "tag")),
  awful.key({ ctrlkey, altkey }, leftkey, awful.tag.viewprev, _opt("view previous", "tag")),
  awful.key({ ctrlkey, altkey }, "h", awful.tag.viewprev, _opt("view previous", "tag")),
  awful.key({ ctrlkey, altkey }, rightkey, awful.tag.viewnext, _opt("view next", "tag")),
  awful.key({ ctrlkey, altkey }, "l", awful.tag.viewnext, _opt("view next", "tag")),

  awful.key({ modkey, shiftkey }, "n", lain.util.add_tag, _opt("add tag", "tag")),
  awful.key({ modkey, shiftkey }, "e", lain.util.rename_tag, _opt("rename tag", "tag")),
  awful.key({ modkey, ctrlkey, shiftkey }, "h", function()
    lain.util.move_tag(-1)
  end, _opt("move tag left", "tag")),
  awful.key({ modkey, ctrlkey, shiftkey }, "l", function()
    lain.util.move_tag(1)
  end, _opt("move tag right", "tag")),
  awful.key({ modkey, shiftkey }, "d", lain.util.delete_tag, _opt("delete tag", "tag")),
}) --}}}

-- Moving {{{
awful.keyboard.append_global_keybindings({
  awful.key({ modkey, shiftkey }, "h", function()
    awful.client.swap.bydirection("left")
  end, _opt("swap with client at left", "move")),
  awful.key({ modkey, shiftkey }, "j", function()
    awful.client.swap.bydirection("down")
  end, _opt("swap with client at bottom", "move")),
  awful.key({ modkey, shiftkey }, "k", function()
    awful.client.swap.bydirection("up")
  end, _opt("swap with client at top", "move")),
  awful.key({ modkey, shiftkey }, "l", function()
    awful.client.swap.bydirection("right")
  end, _opt("swap with client at right", "move")),

  awful.key({ modkey, shiftkey }, "v", function()
    local focused = client.focus
    if not focused then
      return
    end
    local tag = awful.tag.add(next_random_icon(), {
      screen = client.focus.screen,
      volatile = true,
      clients = {
        client.focus,
      },
      layout = awful.layout.layouts[1],
    })
    focused:tags({ tag })
    tag:view_only()
    -- Prevent being unreachable.
    awful.placement.no_offscreen(focused)
  end, _opt("move client to a scratch tag", "move")),

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
  end, _opt("move client to previous tag", "move")),

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
  end, _opt("move client to next tag", "move")),
}) --}}}

-- Focusing {{{
awful.keyboard.append_global_keybindings({
  awful.key({ modkey }, "u", awful.client.urgent.jumpto, _opt("jump to urgent client", "focus")),

  awful.key({ modkey }, tabkey, function()
    awful.spawn("rofi -show window -modi window", nilfn)
  end, { description = "cycle through all clients", group = "focus" }),

  awful.key({ altkey }, tabkey, function()
    awful.client.focus.byidx(1)
  end, _opt("focus next by index", "focus")),

  awful.key({ modkey }, "h", function()
    awful.client.focus.bydirection("left")
    if client.focus then
      client.focus:raise()
    end
  end, _opt("focus client on the left", "focus")),
  awful.key({ modkey }, "j", function()
    awful.client.focus.bydirection("down")
    if client.focus then
      client.focus:raise()
    end
  end, _opt("focus client on the bottom", "focus")),
  awful.key({ modkey }, "k", function()
    awful.client.focus.bydirection("up")
    if client.focus then
      client.focus:raise()
    end
  end, _opt("focus client on the top", "focus")),
  awful.key({ modkey }, "l", function()
    awful.client.focus.bydirection("right")
    if client.focus then
      client.focus:raise()
    end
  end, _opt("focus client on the right", "focus")),

  awful.key({ modkey, ctrlkey }, "j", function()
    awful.screen.focus_relative(1)
  end, _opt("focus the next screen", "focus")),
  awful.key({ modkey, ctrlkey }, "k", function()
    awful.screen.focus_relative(-1)
  end, _opt("focus the previous screen", "focus")),

  awful.key({ altkey }, esckey, function()
    local c = awful.client.focus.history.list[2]
    client.focus = c
    local t = client.focus and client.focus.first_tag or nil
    if t then
      t:view_only()
    end
    c:raise()
  end, _opt("go back", "focus")),
}) --}}}

-- Layout {{{
awful.keyboard.append_global_keybindings({
  awful.key({ modkey }, rightkey, function()
    awful.tag.incmwfact(0.05)
  end, _opt("increase master width factor", "layout")),
  awful.key({ modkey }, leftkey, function()
    awful.tag.incmwfact(-0.05)
  end, _opt("decrease master width factor", "layout")),
  awful.key({ modkey, altkey }, "h", function()
    awful.tag.incnmaster(1, nil, true)
  end, _opt("increase the number of master clients", "layout")),
  awful.key({ modkey, altkey }, "l", function()
    awful.tag.incnmaster(-1, nil, true)
  end, _opt("decrease the number of master clients", "layout")),
  awful.key({ modkey, altkey }, "j", function()
    awful.tag.incncol(1, nil, true)
  end, _opt("increase the number of columns", "layout")),
  awful.key({ modkey, altkey }, "k", function()
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
}) --}}}

-- Program Launchers {{{
awful.keyboard.append_global_keybindings({
  awful.key({ modkey }, returnkey, function()
    awful.spawn.easy_async(terminal, nilfn)
  end, _opt("open a terminal", "launcher")),
  awful.key({ modkey, shiftkey }, returnkey, function()
    awful.spawn.easy_async(aux_terminal, nilfn)
  end, _opt("open the auxiliary terminal", "launcher")),
  awful.key({ modkey }, "b", function()
    awful.spawn.easy_async(browser, nilfn)
  end, _opt(browser, "launcher")),
  awful.key({ modkey }, "e", function()
    awful.spawn.easy_async(filemanager, nilfn)
  end, _opt(filemanager, "launcher")),

  awful.key({ altkey }, spacekey, function()
    awful.spawn.easy_async("rofi -show combi", nilfn)
  end, _opt("show rofi", "launcher")),

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
    awful.spawn.easy_async("rofi -show calc -modi calc -no-show-match -no-sort", nilfn)
  end, { description = "show calculator", group = "launcher" }),
}) --}}}

-- Media {{{
awful.keyboard.append_global_keybindings({
  awful.key({ modkey }, "v", function()
    awful.spawn.easy_async("pavucontrol", nilfn)
  end, _opt("pulseaudio control", "media")),
  awful.key({}, "XF86AudioRaiseVolume", function()
    awesome.emit_signal("widget::volume_osd_slider", 5)
    awesome.emit_signal("module::volume_osd:show", true)
  end, _opt("increase volume", "media")),
  awful.key({}, "XF86AudioLowerVolume", function()
    awesome.emit_signal("widget::volume_osd_slider", -5)
    awesome.emit_signal("module::volume_osd:show", true)
  end, _opt("decrease volume", "media")),
  awful.key({}, "XF86AudioMute", function()
    os.execute("amixer -q set Master toggle")
  end, _opt("mute volume", "media")),
  awful.key({ ctrlkey, shiftkey }, "m", function()
    os.execute(string.format("amixer -q set %s 100%%", "Master"))
    beautiful.volume.update()
  end, _opt("max volume", "media")),
  awful.key({ ctrlkey, shiftkey }, "0", function()
    os.execute(string.format("amixer -q set %s 0%%", "Master"))
    beautiful.volume.update()
  end, _opt("min volume", "media")),

  --Media keys supported by mpd.
  awful.key({}, "XF86AudioPlay", function()
    awful.spawn.easy_async("mpc toggle", nilfn)
  end, _opt("toggle play music", "media")),
  awful.key({}, "XF86AudioNext", function()
    awful.spawn.easy_async("mpc next", nilfn)
  end, _opt("next tune", "media")),
  awful.key({}, "XF86AudioPrev", function()
    awful.spawn.easy_async("mpc prev", nilfn)
  end, _opt("previous tune", "media")),
  awful.key({}, "XF86AudioStop", function()
    awful.spawn.easy_async("mpc stop", nilfn)
  end, _opt("stop playing", "media")),
}) --}}}

-- Brightness {{{
awful.keyboard.append_global_keybindings({
  awful.key({}, "XF86MonBrightnessUp", function()
    awesome.emit_signal("widget::brightness_osd_slider", 5)
    awesome.emit_signal("module::brightness_osd:show", true)
  end, _opt("increase brightness +5%", "brightness")),
  awful.key({}, "XF86MonBrightnessDown", function()
    awesome.emit_signal("widget::brightness_osd_slider", -5)
    awesome.emit_signal("module::brightness_osd:show", true)
  end, _opt("decrease brightness 5%", "brightness")),
}) --}}}

-- Bind all key numbers to tags {{{
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
  awful.keyboard.append_global_keybindings({
    -- View tag {{{
    awful.key({ modkey }, "#" .. i + 9, function()
      local focused = awful.screen.focused()
      local cur_tag = focused.tags[i]
      if cur_tag then
        cur_tag:view_only()
      end
    end),
    --}}}

    -- Toggle tag display {{{
    awful.key({ modkey, ctrlkey }, "#" .. i + 9, function()
      local focused = awful.screen.focused()
      local cur_tag = focused.tags[i]
      if cur_tag then
        awful.tag.viewtoggle(cur_tag)
      end
    end),
    --}}}

    -- Move client to tag {{{
    awful.key({ modkey, shiftkey }, "#" .. i + 9, function()
      if client.focus then
        local cur_tag = client.focus.screen.tags[i]
        if cur_tag then
          client.focus:move_to_tag(cur_tag)
        end
      end
    end),
    --}}}

    -- Toggle tag on focused client {{{
    awful.key({ modkey, ctrlkey, shiftkey }, "#" .. i + 9, function()
      if client.focus then
        local cur_tag = client.focus.screen.tags[i]
        if cur_tag then
          client.focus:toggle_tag(cur_tag)
        end
      end
    end),
    --}}}
  })
end
--}}}

-- vim: fdm=marker fdl=0
