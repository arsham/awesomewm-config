local awful = require("awful")
local wibox = require("wibox")
local vicious = require("vicious")
local theme = require("theme.theme")
local lain = require("lain")
local markup = lain.util.markup

local sign_colour = "#A13016"

local cpuwidget = wibox.widget.graph()
cpuwidget:set_width(100)
cpuwidget:set_background_color("#232627")
cpuwidget:set_color({
  type = "linear",
  from = { 0, 0 },
  to = { 0, 55 },
  stops = {
    { 0, "#742249" },
    { 0.8, "#746122" },
    { 1, "#487422" },
  },
})
vicious.cache(vicious.widgets.cpu)
vicious.register(cpuwidget, vicious.widgets.cpu, "$1", 0.5)

local fanwidget = wibox.widget.graph()
fanwidget:set_width(100)
fanwidget:set_background_color("#232627")
fanwidget:set_color({
  type = "linear",
  from = { 0, 0 },
  to = { 0, 55 },
  stops = {
    { 0, "#74223B" },
    { 0.8, "#662274" },
    { 1, "#222974" },
  },
})
vicious.register(fanwidget, require("arsham.widgets.fan"), "$1", 1)

local thermal = wibox.widget.graph()
thermal:set_width(100)
thermal:set_color({
  type = "linear",
  from = { 0, 0 },
  to = { 200, 0 },
  stops = {
    { 0, "#FF5656" },
    { 0.4, "#CFC396" },
    { 1, "#AECF96" },
  },
})
vicious.cache(vicious.widgets.thermal)
vicious.register(thermal, vicious.widgets.thermal, "$1", 1, "coretemp-isa-0000")

local memwidget = wibox.widget.textbox()
vicious.register(memwidget, require("arsham.widgets.mem"), function(_, args)
  return markup.fontfg(theme.font_name .. "19", sign_colour, " ")
    .. markup.fontfg(theme.font_name .. "12", "#A1D571", ("%.2f GiB"):format(args[2]))
end, 5)

local function get_net_graph(tag)
  local net_down_graph = wibox.widget.graph()
  net_down_graph:set_width(100)
  net_down_graph:set_background_color("#232627")
  net_down_graph:set_scale(true)
  net_down_graph:set_color({
    type = "linear",
    from = { 0, 0 },
    to = { 0, 55 },
    stops = {
      { 0, "#056B11" },
      { 0.8, "#09C21F" },
      { 1, "#55F768" },
    },
  })
  vicious.register(net_down_graph, vicious.widgets.net, "$" .. tag, 2)
  return net_down_graph
end

local function get_net_speed(icon, tag1, tag2)
  local net_down_speed = wibox.widget.textbox(
    markup.fontfg(theme.font_name .. "15", sign_colour, icon)
  )
  -- local net_down_speed = wibox.widget.textbox()
  -- vicious.register(net_down_speed, vicious.widgets.net, function(_, args)
  --   local value = tonumber(args[tag1])
  --   local unit = "Kb/s"
  --   if value > 1024 then
  --     value = tonumber(args[tag2])
  --     unit = "Mb/s"
  --   end
  --
  --   local speed = ("%.2f %s"):format(value, unit)
  --   local pad = string.rep(" ", 10 - #speed)
  --   return markup_font_colour(theme.font_name .. "15", sign_colour, icon)
  --     .. markup_font_colour(theme.font_name .. "11", "#A1D571", pad .. speed .. " ")
  -- end, 0.5)
  return net_down_speed
end

-- Battery
return {
  cpuwidget = cpuwidget,
  thermal = thermal,
  memwidget = memwidget,
  -- batwidget = batbox,
  fanwidget = fanwidget,
  net_down_graph = get_net_graph("{wlp59s0 down_kb}"),
  net_up_graph = get_net_graph("{wlp59s0 up_kb}"),
  net_down_speed = get_net_speed("  ", "{wlp59s0 down_kb}", "{wlp59s0 down_mb}"),
  net_up_speed = get_net_speed(" 祝 ", "{wlp59s0 up_kb}", "{wlp59s0 up_mb}"),
}
