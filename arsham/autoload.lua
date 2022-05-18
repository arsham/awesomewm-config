local naughty = require("naughty")
local awful = require("awful")

local function run_once(item)
  local cmd = item.cmd
  local name = item.name
  local kill = item.kill
  if kill then
    local _, err = awful.spawn.with_shell("pkill " .. kill)
    if err then
      naughty.notify({
        preset = naughty.config.presets.warning,
        title = "Killed " .. name,
        text = err,
      })
    end
  end

  local cmd_str = ""
  if name then
    cmd_str = string.format("pgrep -u $USER '%s' > /dev/null || ", name)
  end

  if item.sleep then
    cmd_str = cmd_str .. string.format("(sleep %d ; %s)", item.sleep, cmd)

    awful.spawn.easy_async_with_shell(cmd_str, function(_, err)
      if err and err ~= "" then
        naughty.notify({
          preset = naughty.config.presets.critical,
          title = "Starting " .. cmd_str,
          text = "Error: " .. err,
        })
      end
    end)
    return
  end

  local _, err = awful.spawn.with_shell(cmd_str .. cmd)
  if err and err ~= "" then
    naughty.notify({
      preset = naughty.config.presets.critical,
      title = "Starting " .. cmd_str,
      text = "Error: " .. err,
    })
  end
end

-- run xrandr --output VGA-1 --primary --mode 1360x768 --pos 0x0 --rotate normal
-- run xrandr --output HDMI2 --mode 1920x1080 --pos 1920x0 --rotate normal --output HDMI1 --primary --mode 1920x1080 --pos 0x0 --rotate normal --output VIRTUAL1 --off
-- autorandr horizontal
run_once({ name = "unclutter", cmd = "unclutter -root" })
run_once({ name = "setxkbmap", cmd = "setxkbmap -option caps:escape" })
run_once({ name = "nm-applet", cmd = "nm-applet" })
run_once({ name = "caffeine", kill = "caffeine", cmd = "caffeine" })
run_once({ name = "xfce4-power-manager", cmd = "xfce4-power-manager" })
run_once({
  name = "/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1",
  cmd = "/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1",
})
run_once({ name = "numlockx", cmd = "numlockx on" })
run_once({ name = "volumeicon", cmd = "volumeicon" })
run_once({ name = "redshift-gtk", cmd = "redshift-gtk", kill = "redshift-gtk" })
run_once({
  name = "variety",
  cmd = "variety --profile /home/arsham/.config/variety/",
  kill = "variety",
  sleep = 1,
})
run_once({ name = "parcellite", cmd = "parcellite", sleep = 3 })
run_once({ name = "syndaemon", cmd = "syndaemon -i 0.5 -t -K -R" })
run_once({
  name = "picom",
  cmd = "picom -b --experimental-backends --backend glx --config  $HOME/.config/awesome/picom.conf",
})
