local terminal = "kitty"
local aux_terminal = "alacritty"
local browser = "firefox"

local vars = {
  keys = { -- Keys {{{
    mod = "Mod4",
    alt = "Mod1",
    ctrl = "Control",
    shift = "Shift",
    up = "Up",
    down = "Down",
    left = "Left",
    right = "Right",
    esc = "Escape",
    ret = "Return",
    space = "space",
    tab = "Tab",
  },
  --}}}

  apps = { -- Apps {{{
    terminal = "prime-run " .. terminal,
    aux_terminal = "prime-run " .. aux_terminal,
    editor = "nvim",
    editor_cmd = "prime-run " .. terminal .. " -e nvim",
    filemanager = "prime-run pcmanfm",
    browser = "prime-run " .. browser,
    shell = "zsh",
  },
  --}}}

  tags = { "➊", "➋", "➌", "➍", "➎", "➏", "➐", "➑", "" },
  extra_tags = { "߷", "☢", "♻", "♼", "✪", "✽", "✿", "⮔", "" },

  wibar = { -- Wibar {{{
    position = "top",
    height = 55,
  },
  --}}}

  theme = {
    icon_size = 100,
  },
}

return vars

-- vim: fdm=marker fdl=0
