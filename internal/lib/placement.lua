local awful = require("awful")
local gears = require("gears")

local M = {}

function M.centered(c)
  return gears.timer.delayed_call(function()
    awful.placement.centered(c, { honor_padding = true, honor_workarea = true })
  end)
end

return M
