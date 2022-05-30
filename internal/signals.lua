local beautiful = require("beautiful") -- Theme handling library
local awful = require("awful") --Everything related to window managment

-- Signal function to execute when a new client appears.{{{
client.connect_signal("manage", function(c)
  if awesome.startup and not c.size_hints.user_position and not c.size_hints.program_position then
    -- Prevent clients from being unreachable after screen count changes.
    awful.placement.no_offscreen(c)
  end
end) --}}}

-- Enable sloppy focus, so that focus follows mouse.{{{
client.connect_signal("mouse::enter", function(c)
  c:emit_signal("request::activate", "mouse_enter", { raise = false })
end) --}}}

client.connect_signal("focus", function(c)
  c.border_color = beautiful.border_focus
end)
client.connect_signal("unfocus", function(c)
  c.border_color = beautiful.border_normal
end)

-- No border for maximized clients{{{
local function border_adjust(c)
  if c.maximized then -- no borders if only 1 client visible
    c.border_width = 0
  elseif #awful.screen.focused().clients > 1 then
    c.border_width = beautiful.border_width
    c.border_color = beautiful.border_focus
  end
end --}}}

client.connect_signal("property::maximized", border_adjust)

-- Steam bug with window outside of the screen
-- client.connect_signal("property::position", function(c)
--      if c.class == 'Steam' then
--          local g = c.screen.geometry
--          if c.y + c.height > g.height then
--              c.y = g.height - c.height
--              naughty.notify{
--                  text = "restricted window: " .. c.name,
--              }
--          end
--          if c.x + c.width > g.width then
--              c.x = g.width - c.width
--          end
--      end
--  end)

-- vim: fdm=marker fdl=0
