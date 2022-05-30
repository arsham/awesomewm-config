local awful = require("awful")
local widget = require("internal.osd.widget")

widget({
  id = "volume_osd",
  text = "Volume",
  get_value = function(the_slider)
    awful.spawn.easy_async_with_shell([[bash -c "amixer -D pulse sget Master"]], function(stdout)
      local volume = string.match(stdout, "(%d?%d?%d)%%")
      the_slider:set_value(tonumber(volume))
    end)
  end,
  set_value = function(value)
    awful.spawn.easy_async_with_shell(
      string.format("amixer -q set %s %d%%", "Master", value),
      function() end
    )
  end,
})

widget({
  id = "brightness_osd",
  text = "Brightness",
  get_value = function(the_slider)
    awful.spawn.easy_async_with_shell("light -G", function(stdout)
      local brightness = string.match(stdout, "(%d+)")
      the_slider:set_value(tonumber(brightness))
    end)
  end,
  set_value = function(value)
    awful.spawn.easy_async_with_shell(
      string.format("brightnessctl -q s %d%%", value),
      function() end
    )
  end,
})
