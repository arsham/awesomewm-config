local naughty = require("naughty")
local ruled = require("ruled")
local awful = require("awful")

naughty.config.defaults.timeout = 10
naughty.config.defaults.hover_timeout = 300

ruled.notification.connect_signal("request::rules", function() --{{{
  -- All notifications will match this rule.
  ruled.notification.append_rule({
    rule = {},
    properties = {
      screen = awful.screen.preferred,
      implicit_timeout = 5,
    },
  })
end) --}}}

naughty.connect_signal("request::display", function(n) --{{{
  n.title = string.format("<span font = 'Noto Sans 16'>%s</span>", n.title)
  naughty.layout.box({ notification = n })
end)
--}}}

local cst = require("naughty.constants") --{{{
naughty.connect_signal("destroyed", function(n, reason)
  if not n.clients then
    return
  end

  if reason == cst.notification_closed_reason.dismissed_by_user then
    for _, c in ipairs(n.clients) do
      c.urgent = true
    end
    return
  end

  for _, c in ipairs(n.clients) do
    if c.class == "Slack" then
      c.urgent = true
    end
  end
end) --}}}

-- vim: fdm=marker fdl=0
