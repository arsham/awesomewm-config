local awesome, root = awesome, root
local awful = require("awful")
local freedesktop = require("freedesktop")
local gears = require("gears")
local hotkeys_popup = require("awful.hotkeys_popup")

local myawesomemenu = {
  {
    "hotkeys",
    function()
      return false, hotkeys_popup.show_help
    end,
  },
  { "arandr", "arandr" },
}

awful.util.mymainmenu = freedesktop.menu.build({
  before = {
    { "Awesome", myawesomemenu },
  },
  after = {
    { "Terminal", awful.util.terminal },
    {
      "Log out",
      function()
        awesome.quit()
      end,
    },
    { "Sleep", "systemctl suspend" },
    { "Restart", "systemctl reboot" },
    { "Shutdown", "systemctl poweroff" },
  },
})

local mymainmenu = awful.util.mymainmenu
-- }}}

-- Mouse bindings {{{
root.buttons(gears.table.join(
  awful.button({}, 3, function()
    mymainmenu:toggle()
  end),
  awful.button({}, 4, awful.tag.viewnext),
  awful.button({}, 5, awful.tag.viewprev)
)) -- }}}
