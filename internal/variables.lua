-- local home = os.getenv("HOME")

local vars = {
  -- Keys {{{
  keys = {
    mod = "Mod4",
    alt = "Mod1",
    ctrl = "Control",
    shift = "Shift",
    left = "Left",
    right = "Right",
    esc = "Escape",
    ret = "Return",
    space = "space",
    tab = "Tab",
  },
  --}}}
  -- Apps {{{
  apps = {
    terminal = "kitty",
    filemanager = "pcmanfm",
    browser = "brave",
    shell = "zsh",
  },
  --}}}
  tags = { "➊", "➋", "➌", "➍", "➎", "➏", "➐", "➑", "" },
  wibox = {
    position = "top",
    height = 55,
  },
  theme = {
    icon_size = 100,
  },
}

return vars

-- vim: fdm=marker fdl=0
