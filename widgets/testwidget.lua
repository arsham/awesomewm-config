local shape = require("gears.shape")
local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local green = "#559955"
local red = "#995555"
local blue = "#3366aa"

local inner = wibox.container.background()
inner.bg = blue

local circle = wibox.widget({
  inner,
  visible = false,
  bg = red,
  thickness = 7,
  paddings = 4,
  widget = wibox.container.arcchart,
  shape = function(cr, width, height)
    shape.partially_rounded_rect(cr, width, height, true, true, false, true, 10)
  end,
})

local tooltip = awful.tooltip({ objects = { circle } })

local timer = gears.timer({
  timeout = 300,
  single_shot = true,
  callback = function()
    circle.visible = false
  end,
})

client.connect_signal("naucious::started", function()
  circle.bg = blue
  circle.visible = true
  timer:stop()
  timer:start()
end)

client.connect_signal("naucious::finished", function()
  timer:stop()
  circle.visible = false
end)

client.connect_signal("naucious::set", function(ok, msg)
  if ok == true then
    circle.bg = green
    tooltip.text = ""
  elseif ok == false then
    circle.bg = red
    if msg then
      tooltip.text = msg
    end
  else
    return
  end
  circle.visible = true
  timer:stop()
  timer:start()
end)

return circle
