local awful = require("awful")
local ruled = require("ruled")
local beautiful = require("beautiful")
local keys = require("config.keybindings")

-- All clients will match this rule {{{
ruled.client.append_rule({
  id = "global",
  rule = {},
  properties = {
    above = false,
    below = false,
    border_color = beautiful.border_color_normal,
    border_width = beautiful.border_width,
    buttons = keys.clientbuttons,
    floating = false,
    focus = awful.client.focus.filter,
    keys = keys.clientkeys,
    maximized = false,
    maximized_horizontal = false,
    maximized_vertical = false,
    ontop = false,
    placement = awful.placement.no_overlap + awful.placement.no_offscreen,
    raise = true,
    screen = awful.screen.preferred,
    sticky = false,
  },
})
--}}}

-- Disabling titlebars {{{
ruled.client.append_rule({
  id = "titlebar_disabled",
  rule_any = { type = { "normal", "dialog" } },
  properties = { titlebars_enabled = false },
}) --}}}

-- Rounded corners {{{
ruled.client.append_rule({
  id = "round_clients",
  rule_any = {
    type = {
      "normal",
      "dialog",
    },
  },
  except_any = {
    name = { "Discord Updater" },
  },
  properties = {
    round_corners = true,
    shape = beautiful.client_shape_rounded,
  },
}) --}}}

-- vim: fdm=marker fdl=0
