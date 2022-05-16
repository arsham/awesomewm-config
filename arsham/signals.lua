local awesome, client = awesome, client
local beautiful = require("beautiful") -- Theme handling library
local awful = require("awful") --Everything related to window managment

-- Signals {{{
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function(c)
  -- Set the windows at the slave,
  -- i.e. put it at the end of others instead of setting it master.
  -- if not awesome.startup then
  --   awful.client.setslave(c)
  -- end

  if awesome.startup and not c.size_hints.user_position and not c.size_hints.program_position then
    -- Prevent clients from being unreachable after screen count changes.
    awful.placement.no_offscreen(c)
  end
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
  c:emit_signal("request::activate", "mouse_enter", { raise = false })
end)

client.connect_signal("focus", function(c)
  c.border_color = beautiful.border_focus
end)
client.connect_signal("unfocus", function(c)
  c.border_color = beautiful.border_normal
end)

-- No border for maximized clients
local function border_adjust(c)
  if c.maximized then -- no borders if only 1 client visible
    c.border_width = 0
  elseif #awful.screen.focused().clients > 1 then
    c.border_width = beautiful.border_width
    c.border_color = beautiful.border_focus
  end
end

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

-- {{{ Notifications
local ruled = require("ruled")
ruled.notification.connect_signal("request::rules", function()
  -- All notifications will match this rule.
  ruled.notification.append_rule({
    rule = {},
    properties = {
      screen = awful.screen.preferred,
      --implicit_timeout = 5,
    },
  })
end)

-- Store notifications to the file
local naughty = require("naughty")
client.connect_signal("added", function(n)
  local file = io.open(os.getenv("HOME") .. "/.config/awesome/tmp/naughty_history", "a")
  file:write(n.title .. ": " .. n.message .. "\n")
  file:close()
end)

-- }}}
