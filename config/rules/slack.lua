local keys = require("config.keybindings")
local awful = require("awful")
local ruled = require("ruled")

--- Slack {{{
ruled.client.append_rule({
  id = "slack",
  rule = { class = "Slack" },
  properties = { tag = awful.screen.focused().tags[9] },
})

ruled.client.append_rule({
  id = "floating_slack",
  rule = {
    class = "Slack",
  },
  except = {
    type = "normal",
  },
  properties = {
    skip_decoration = true,
    ontop = false,
    floating = true,
    focus = awful.client.focus.filter,
    raise = false,
    keys = keys.clientkeys,
    buttons = keys.clientbuttons,
    placement = awful.placement.centered,
  },
}) --}}}

-- vim: fdm=marker fdl=0
