local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")
local hider = require("lib.outside_click_hides")
local theme = require("theme.theme")

local bin_cmd = "dropbox-cli "

local dropbox_widget = wibox.widget({ --{{{
  {
    id = "icon",
    image = theme.dropbox_status_logo,
    widget = wibox.widget.imagebox,
  },
  margins = 4,
  layout = wibox.container.margin,
  set_image = function(self, path)
    self.icon.image = path
  end,
}) --}}}

local tooltip = awful.tooltip({
  objects = { dropbox_widget },
  text = "Starting...",
})

client.connect_signal("go::dropbox:value", function(msg, icon)
  icon = theme[icon]
  tooltip:set_markup(msg)
  dropbox_widget:set_image(icon)
end)

local menu_items = { --{{{
  { name = "Stop", icon_name = theme.dropbox_status_x, command = "stop" },
  { name = "Start", icon_name = theme.dropbox_loading_icon, command = "start" },
} --}}}

local popup = awful.popup({
  ontop = true,
  visible = false,
  shape = function(cr, width, height)
    gears.shape.rounded_rect(cr, width, height, 4)
  end,
  border_width = 1,
  border_color = beautiful.bg_focus,
  maximum_width = 400,
  offset = { y = 5 },
  widget = {},
})
local rows = { layout = wibox.layout.fixed.vertical }

local function setup_menu_item(item) --{{{
  local row = wibox.widget({ --{{{
    {
      {
        {
          image = item.icon_name,
          forced_width = 44,
          forced_height = 44,
          widget = wibox.widget.imagebox,
        },
        {
          text = item.name,
          widget = wibox.widget.textbox,
        },
        spacing = 12,
        layout = wibox.layout.fixed.horizontal,
      },
      margins = 8,
      widget = wibox.container.margin,
    },
    bg = beautiful.bg_normal,
    widget = wibox.container.background,
  })
  --}}}

  -- Change item background on mouse hover{{{
  row:connect_signal("mouse::leave", function(c)
    c:set_bg(beautiful.bg_normal)
  end)
  row:connect_signal("mouse::enter", function(c)
    c:set_bg(beautiful.bg_focus)
  end)
  --}}}

  -- Change cursor on mouse hover{{{
  local old_cursor, old_wibox
  row:connect_signal("mouse::enter", function()
    local wb = mouse.current_wibox
    if wb then
      old_cursor, old_wibox = wb.cursor, wb
      wb.cursor = "hand1"
    end
  end)
  row:connect_signal("mouse::leave", function()
    if old_wibox then
      old_wibox.cursor = old_cursor
      old_wibox = nil
    end
  end)
  --}}}

  -- Mouse click handler{{{
  row:buttons(awful.util.table.join(awful.button({}, 1, function()
    popup.visible = not popup.visible
    awful.spawn.with_shell("DISPLAY= " .. bin_cmd .. item.command)
  end)))
  --}}}

  table.insert(rows, row)
end --}}}

for _, item in ipairs(menu_items) do
  setup_menu_item(item)
end

popup:setup(rows)
hider.popup(popup, nil, true)

-- Mouse click handler{{{
dropbox_widget:buttons(awful.util.table.join(awful.button({}, 1, function()
  if popup.visible then
    popup.visible = not popup.visible
  else
    popup:move_next_to(mouse.current_widget_geometry)
  end
end)))
--}}}

return dropbox_widget

-- vim: fdm=marker fdl=0
