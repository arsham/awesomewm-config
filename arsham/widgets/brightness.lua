----------------------------------------------
--
-- Control brightness of device
-- Hover over slider for tooltip listing all controllable brightness
-- Hover over textbox for menu to switch control of brightness
--
-- Author: Seth Barberee <seth.barberee@gmail.com>
----------------------------------------------

local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")

-- TODO add brightness icon
local brightness = wibox.widget {
    {
        {
            {
                id      = 'textbox',
                text    = "50",
                halign  = 'center',
                valign  = 'center',
                widget  = wibox.widget.textbox
            },
            right = 2,
            left = 2,
            widget = wibox.container.margin,
        },
        {
            id                  = 'bar',
            maximum             = 100,
            value               = 50,
            forced_height       = 20,
            forced_width        = 100,
            bar_height          = 3,
            bar_active_color    = beautiful.bg_focus,
            bar_color           = beautiful.bg_normal,
            handle_color        = beautiful.bg_focus,
            widget              = wibox.widget.slider,
        },
        layout = wibox.layout.align.horizontal
    },
    right = 5,
    widget = wibox.container.margin
}

local sink = ""

local brightness_t = awful.tooltip {
    objects = {brightness}, -- Attach the bar
    timer_function = function()
        awful.spawn.easy_async_with_shell("xbacklight -list", function(stdout)
            sink = "Brightness: \n" .. stdout
        end)
        return sink
    end,
}

local function update_brightness()
    awful.spawn.easy_async_with_shell("xbacklight -get", function(stdout)
        brightness:get_children_by_id("textbox")[1].text = "B: " .. stdout
        brightness:get_children_by_id("bar")[1].value    = tonumber(stdout)
    end)
end

function brightness.raise_brightness()
    awful.spawn.with_shell("xbacklight -inc 5")
    update_brightness()
end

function brightness.lower_brightness()
    awful.spawn.with_shell("xbacklight -dec 5")
    update_brightness()
end

brightness:get_children_by_id("bar")[1]:connect_signal('property::value', function()
    awful.spawn.easy_async_with_shell("xbacklight -set " .. brightness:get_children_by_id("bar")[1].value, function()
        update_brightness()
    end)
end)

update_brightness()

return setmetatable(brightness, { __call = function(_, ...) update_brightness() return brightness end})
