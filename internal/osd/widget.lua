local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local theme = require("theme.theme")

local defaults = { --{{{
  id = nil,
  text = "OSD",
  font = "sans bold 12",
  align = "left",
  valign = "center",
  widget = wibox.widget.textbox,
  top = dpi(12),
  bottom = dpi(12),
  spacing = dpi(24),
  osd_height = dpi(100),
  osd_width = dpi(300),
  osd_margin = dpi(20),
  image = theme.widget.vol_svg,
  step = 5,
  get_value = function(the_slider)
    the_slider:set_value(100)
  end,
  set_value = function() end,
} --}}}

local osd = {}

function osd.new(conf) --{{{
  assert(conf, "You need to pass a config table!")
  assert(conf.id, "You need to pass a widget id!")
  config = require("internal.lib.table").tbl_extend(defaults, conf)
  osd.config = config
  osd:create_widget()
  return osd
end --}}}

function osd:place_top_right() --{{{
  local focused = awful.screen.focused()
  local overlay = focused[self.config.id .. "_overlay"]
  awful.placement.top_right(overlay, {
    margins = {
      left = 0,
      right = self.config.osd_margin,
      top = self.config.osd_margin,
      bottom = 0,
    },
    honor_workarea = true,
  })
  -- overlay:connect_signal("request::manage", function(c)
  --   require("internal.lib.debug").dump_to(nil, c)
  -- end)
end --}}}

function osd:keep_ticking() --{{{
  if self.osd_show_timer.started then
    self.osd_show_timer:again()
  else
    self.osd_show_timer:start()
  end
end --}}}

function osd:signal(str) --{{{
  return string.format(str, self.config.id)
end --}}}

function osd:update_slider_value() --{{{
  local level = self.the_slider_osd:get_value()
  self.osd_value.text = level .. "%"
  self.config.set_value(level)
  self.the_slider:set_value(level)
  if awful.screen.focused()[self.config.id] then
    self:module_show(true)
  end
end --}}}

function osd:module_show(bool) --{{{
  self:place_top_right()
  local w = awful.screen.focused()[self.config.id .. "_overlay"]
  w.visible = bool
  if bool then
    self.osd_show_timer.visible = true
    self:keep_ticking()
  else
    if self.osd_show_timer.started then
      self.osd_show_timer:stop()
      self.osd_show_timer.visible = false
    end
  end
end --}}}

function osd:create_popup(s)
  s = s or {}
  s[self.config.id] = false
  local popup = self.config.id .. "_overlay"

  s[popup] = awful.popup({ --{{{
    widget = {
      -- Removing this block will cause an error...
    },
    ontop = true,
    visible = false,
    type = "notification",
    screen = s,
    height = self.config.osd_height,
    width = self.config.osd_width,
    maximum_height = self.config.osd_height,
    maximum_width = self.config.osd_width,
    offset = dpi(5),
    shape = gears.shape.rectangle,
    bg = beautiful.transparent,
    preferred_anchors = "middle",
    preferred_positions = { "left", "right", "top", "bottom" },
  }) --}}}

  s[popup]:setup({ --{{{
    {
      {
        {
          layout = wibox.layout.align.horizontal,
          expand = "none",
          forced_height = dpi(48),
          self.osd_header,
          nil,
          self.osd_value,
        },
        self.widget_slider_osd,
        layout = wibox.layout.fixed.vertical,
      },
      left = dpi(24),
      right = dpi(24),
      widget = wibox.container.margin,
    },
    bg = theme.bg_focus,
    shape = gears.shape.rounded_rect,
    widget = wibox.container.background(),
  }) --}}}

  -- Keep the popup on mouse hover/moving {{{
  s[popup]:connect_signal("mouse::enter", function()
    awful.screen.focused()[self.config.id] = true
    self:keep_ticking()
  end)
  s[popup]:connect_signal("mouse::hover", function()
    awful.screen.focused()[self.config.id] = true
    self:keep_ticking()
  end)
  s[popup]:connect_signal("mouse::move", function()
    awful.screen.focused()[self.config.id] = true
    self:keep_ticking()
  end) --}}}
end

function osd:create_widget()
  self.osd_header = wibox.widget({ --{{{
    text = self.config.text,
    font = self.config.font,
    align = self.config.align,
    valign = self.config.valign,
    widget = wibox.widget.textbox,
  }) --}}}

  self.osd_value = wibox.widget({ --{{{
    text = self.config.text,
    font = self.config.font,
    align = self.config.align,
    valign = self.config.valign,
    widget = wibox.widget.textbox,
  }) --}}}

  self.slider_osd = wibox.widget({ --{{{
    nil,
    {
      id = self.config.id,
      bar_shape = gears.shape.rounded_rect,
      bar_height = dpi(2),
      bar_color = "#ffffff20",
      bar_active_color = "#f2f2f2EE",
      handle_color = "#ffffff",
      handle_shape = gears.shape.circle,
      handle_width = dpi(15),
      handle_border_color = "#00000012",
      handle_border_width = dpi(1),
      maximum = 100,
      widget = wibox.widget.slider,
    },
    nil,
    expand = "none",
    layout = wibox.layout.align.vertical,
  }) --}}}
  self.the_slider_osd = self.slider_osd[self.config.id]

  local slider = wibox.widget({ --{{{
    nil,
    {
      id = "the_slider",
      bar_shape = gears.shape.rounded_rect,
      bar_height = dpi(24),
      bar_color = "#ffffff20",
      bar_active_color = "#f2f2f2EE",
      handle_color = "#ffffff",
      handle_shape = gears.shape.circle,
      handle_width = dpi(24),
      handle_border_color = "#00000012",
      handle_border_width = dpi(1),
      maximum = 100,
      widget = wibox.widget.slider,
    },
    nil,
    expand = "none",
    forced_height = dpi(24),
    layout = wibox.layout.align.vertical,
  }) --}}}
  self.the_slider = slider.the_slider

  self.osd_show_timer = gears.timer({ --{{{
    timeout = 2,
    autostart = true,
    callback = function()
      local focused = awful.screen.focused()
      focused[self.config.id .. "_overlay"].visible = false
      focused[self.config.id] = false
    end,
  }) --}}}

  self.the_slider_osd:connect_signal("property::value", function() --{{{
    self:update_slider_value()
  end) --}}}

  awesome.connect_signal(self:signal("module::%s:show"), function(bool) --{{{
    self:module_show(bool)
  end) --}}}

  self.the_slider_osd:connect_signal("button::press", function() --{{{
    awful.screen.focused()[self.config.id] = true
  end) --}}}

  self.the_slider_osd:connect_signal("mouse::enter", function() --{{{
    awful.screen.focused()[self.config.id] = true
  end) --}}}

  local function set_value(value) --{{{
    self.the_slider_osd:set_value(value)
  end --}}}

  local icon = wibox.widget({ --{{{
    {
      image = theme.widget.vol_svg,
      resize = true,
      widget = wibox.widget.imagebox,
    },
    top = self.config.top,
    bottom = self.config.bottom,
    widget = wibox.container.margin,
  }) --}}}

  self.widget_slider_osd = wibox.widget({ --{{{
    icon,
    self.slider_osd,
    spacing = self.config.spacing,
    layout = wibox.layout.fixed.horizontal,
  }) --}}}

  screen.connect_signal("request::desktop_decoration", function(s) --{{{
    self:create_popup(s)
  end) --}}}

  self.the_slider:connect_signal("property::value", function() --{{{
    local level = self.the_slider:get_value()
    set_value(level)
  end) --}}}

  self.the_slider:buttons(gears.table.join( --{{{
    awful.button({}, 4, nil, function()
      local level = self.the_slider:get_value()
      if level > 100 then
        self.the_slider:set_value(100)
        return
      end
      self.the_slider:set_value(level + self.config.step)
    end),
    awful.button({}, 5, nil, function()
      local level = self.the_slider:get_value()
      if level < 0 then
        self.the_slider:set_value(0)
        return
      end
      self.the_slider:set_value(level - self.config.step)
    end)
  )) --}}}

  self.config.get_value(self.the_slider)

  -- The emit will come from the global keybind{{{
  awesome.connect_signal(self:signal("widget::%s_slider"), function(value)
    self.config.set_value(self.the_slider:get_value() + value)
    self.config.get_value(self.the_slider)
  end) --}}}

  -- The emit will come from the OSD{{{
  awesome.connect_signal(self:signal("widget::%s:update_slider"), function(value)
    value = tonumber(value)
    self.config.set_value(value)
    self.the_slider:set_value(value)
  end)
end --}}}

return setmetatable({}, { --{{{
  __call = function(_, conf)
    assert(conf, "You need to pass a config table!")
    assert(conf.id, "You need to pass a widget id!")
    config = require("internal.lib.table").tbl_extend(defaults, conf)
    t = {
      config = config,
    }
    setmetatable(t, { __index = osd })
    t:create_widget()
    return t
  end,
}) --}}}

-- vim: fdm=marker fdl=0
