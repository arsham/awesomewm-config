local naughty = require("naughty")
local awful = require("awful")

local function with_sleep(fn, sleep)
  if sleep then
    awful.spawn.easy_async_with_shell(string.format("sleep %d", sleep), fn)
  else
    fn()
  end
end

local function async(cmd)
  awful.spawn.easy_async_with_shell(cmd, function(_, err)
    if err and err ~= "" then
      naughty.notify({
        preset = naughty.config.presets.critical,
        title = "Starting " .. cmd,
        text = "Error: " .. err,
        timeout = 4,
      })
    end
  end)
end

local function run_once_ps(item)
  local cmd = item.cmd
  local match = item.match
  local cmd_str = string.format("ps -C %s|wc -l", match)
  with_sleep(function()
    awful.spawn.easy_async_with_shell(cmd_str, function(stdout)
      if tonumber(stdout) ~= 2 then
        awful.spawn(cmd, false)
      end
    end)
  end, item.sleep)
end

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
        timeout = 4,
      })
    end
  end

  local cmd_str = ""
  if name then
    cmd_str = string.format("pgrep -u $USER '%s' > /dev/null || ", name)
  end

  with_sleep(function()
    async(cmd_str .. cmd)
  end, item.sleep)
end

local function run_once_grep(item)
  local cmd = item.cmd
  local match = item.match
  with_sleep(function()
    awful.spawn.easy_async_with_shell(
      string.format("ps aux | grep '%s' | grep -v 'grep'", match),
      function(stdout)
        if stdout == "" or stdout == nil then
          async(cmd)
        end
      end
    )
  end, item.sleep)
end

-- run xrandr --output VGA-1 --primary --mode 1360x768 --pos 0x0 --rotate normal
-- run xrandr --output HDMI2 --mode 1920x1080 --pos 1920x0 --rotate normal --output HDMI1 --primary --mode 1920x1080 --pos 0x0 --rotate normal --output VIRTUAL1 --off
-- autorandr horizontal
run_once({ name = "unclutter", cmd = "unclutter -root" })
run_once({ name = "setxkbmap", cmd = "setxkbmap -option caps:escape" })
run_once({ name = "nm-applet", cmd = "nm-applet" })
run_once_grep({ cmd = "caffeine", match = "caffeine-ng" })
run_once({ name = "xfce4-power-manager", cmd = "xfce4-power-manager" })
run_once_ps({
  match = "polkit-gnome-authentication-agent-1",
  cmd = "/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1",
})
run_once({ name = "numlockx", cmd = "numlockx on" })
run_once({ name = "volumeicon", cmd = "volumeicon" })
run_once({ name = "redshift-gtk", cmd = "redshift-gtk" })
run_once_ps({
  match = "variety",
  cmd = "variety --profile /home/arsham/.config/variety/",
  sleep = 1,
})
run_once({ name = "parcellite", cmd = "parcellite", sleep = 3 })
run_once({ name = "syndaemon", cmd = "syndaemon -i 0.5 -t -K -R" })
run_once({
  name = "picom",
  cmd = "picom -b --experimental-backends --backend glx --config  $HOME/.config/awesome/picom.conf",
})
