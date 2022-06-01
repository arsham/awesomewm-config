local awesome, root = awesome, root
local awful = require("awful")
local freedesktop = require("freedesktop")
local gears = require("gears")
-- Enable hotkeys help widget for VIM and other apps when client with a
-- matching name is opened:
local hotkeys_popup = require("awful.hotkeys_popup")

awful.util.mymainmenu = freedesktop.menu.build({
  before = {
    {
      "Favourites",
      {
        {
          "hotkeys",
          function()
            return hotkeys_popup.show_help()
          end,
        },
        { "Display Settings", "arandr" },
      },
    },
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

local hider = require("lib.outside_click_hides")
hider.menu(awful.util.mymainmenu, nil, true)

-- }}}

-- Mouse bindings {{{
root.buttons(gears.table.join(awful.button({}, 3, function()
  awful.util.mymainmenu:toggle()
end))) -- }}}
