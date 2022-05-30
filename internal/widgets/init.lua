-- Imports {{{
local wibox = require("wibox")
local vicious = require("vicious")
local theme = require("theme.theme")
local lain = require("lain")
local markup = lain.util.markup
local dpi = require("beautiful.xresources").apply_dpi
local gears = require("gears")
local awful = require("awful")
local fmt = require("internal.lib.fmt")

local sign_colour = "#43A04799"
local widget_color = "#3D75C6CC"
local sign_font = theme.font_name .. "16"
local widget_font = theme.font_name_mono .. "10"
--}}}

local function go_widget(conf) --{{{
  local graph = wibox.widget.graph({
    align = "center",
    valign = "center",
  })
  graph:set_max_value(100)
  graph:set_width(conf.width or 150)
  graph:set_background_color(conf.bg)
  graph:set_scale(conf.scale or false)
  graph:set_color({
    type = "linear",
    from = conf.from or { 0, 0 },
    to = conf.to,
    stops = conf.stops,
  })
  awful.tooltip({
    objects = { graph },
    text = conf.tooltip or "Usage",
  })

  if conf.label_md then
    local label = wibox.widget({
      markup = conf.label_md,
      widget = wibox.widget.textbox,
      align = "center",
      valign = "center",
    })
    local w = wibox.widget({
      graph,
      wibox.container.margin(label, 0, conf.margin or dpi(10)),
      layout = wibox.layout.stack,
      horizontal_offset = 15,
    })
    function w:add_value(v)
      graph:add_value(v)
    end
    return w
  end

  return graph
end
--}}}

local function cpuwidget() --{{{
  return vicious_widget({
    bg = "#232627",
    widget = vicious.widgets.cpu,
    format = "$1",
    label_md = markup.fontfg(theme.font_name .. "15", "#CC993399", ""),
    to = { 0, 55 },
    stops = {
      { 0, "#742249" },
      { 0.8, "#746122" },
      { 1, "#487422" },
    },
    tooltip = "CPU Load",
  })
end --}}}

local function fanwidget() --{{{
  local widget = go_widget({
    bg = "#232627",
    label_md = markup.fontfg(theme.font_name .. "15", "#1D99F399", ""),
    to = { 0, 35 },
    stops = {
      { 0, "#74223B" },
      { 0.4, "#442A6C" },
      { 1, "#222974" },
    },
    tooltip = "Fan Speed",
  })

  client.connect_signal("go::cpu:fan", function(value)
    widget:add_value(value)
  end)

  return widget
end --}}}

local function generic_thermal(signal) --{{{
  local widget = go_widget({
    bg = "#232627",
    label_md = markup.fontfg(theme.font_name .. "15", "#D8411D99", ""),
    to = { 0, 35 },
    stops = {
      { 0, "#E30101" },
      { 0.3, "#74223B" },
      { 1, "#6D72B0" },
    },
    tooltip = "Temperature",
  })
  client.connect_signal(signal, function(value)
    widget:add_value(value)
  end)

  return widget
end
--}}}

local function thermalwidget_cpu()
  return generic_thermal("go::cpu:temp")
end

return {
  cpuwidget = cpuwidget,
  thermal_cpu = thermalwidget_cpu,
  fanwidget = fanwidget,
}

-- vim: fdm=marker fdl=0
