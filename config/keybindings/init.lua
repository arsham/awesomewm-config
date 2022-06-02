local globalkeys = require("config.keybindings.globalkeys")
root.keys(globalkeys)

return {
  globalkeys = globalkeys,
  clientbuttons = require("config.keybindings.clientbuttons"),
  clientkeys = require("config.keybindings.clientkeys"),
}

-- vim: fdm=marker fdl=1
