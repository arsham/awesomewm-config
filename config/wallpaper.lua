local awful = require("awful")
local gears = require("gears")

local cmd = [[nitrogen --set-scaled --random /home/arsham/Pictures/Wallpapers/WallPaper\ HD3]]
local timer = gears.timer.start_new(60, function()
  awful.spawn.easy_async_with_shell(cmd, function() end)
  return true
end)
timer:emit_signal("timeout")
