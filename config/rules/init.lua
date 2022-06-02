local ruled = require("ruled")

ruled.client.connect_signal("request::rules", function()
  require("config.rules.global")
  require("config.rules.floating")
  require("config.rules.media")
  require("config.rules.slack")

  -- Terminal emulators {{{
  ruled.client.append_rule({
    id = "terminals",
    rule_any = {
      class = {
        "URxvt",
        "XTerm",
        "UXTerm",
        "kitty",
        "K3rmit",
        "alacritty",
      },
    },
    properties = {
      tag = "1",
      switch_to_tags = true,
      size_hints_honor = false,
    },
  }) --}}}

  -- Internet {{{
  ruled.client.append_rule({
    id = "internet",
    rule_any = {
      class = {
        "Brave-browser",
        "firefox",
        "Tor Browser",
        "discord",
        "Chromium",
        "Google-chrome",
      },
    },
  })

  ruled.client.append_rule({
    id = "hidden",
    rule_any = {
      name = {
        "meet.google.com is sharing your screen.",
      },
    },
    properties = { hidden = true },
  })
  --}}}

  -- Text editors and word processing {{{
  ruled.client.append_rule({
    id = "text",
    rule_any = {
      class = {
        "Subl3",
      },
      name = {
        "LibreOffice",
        "libreoffice",
      },
    },
  }) --}}}

  -- File managers {{{
  ruled.client.append_rule({
    id = "files",
    rule_any = {
      class = {
        "pcmanfm",
        "dolphin",
        "ark",
        "Nemo",
        "File-roller",
      },
    },
  }) --}}}

  -- Sandboxes and VMs {{{
  ruled.client.append_rule({
    id = "sandbox",
    rule_any = {
      class = {
        "VirtualBox Manage",
        "VirtualBox Machine",
        "Gnome-boxes",
        "Virt-manager",
      },
    },
    properties = {
      tag = "8",
    },
  }) --}}}
end)

-- vim: fdm=marker fdl=0
