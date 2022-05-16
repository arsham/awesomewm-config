local helpers = require("vicious.helpers")
local re = [[fan%d:%s+(%d+) RPM]]

return helpers.setcall(function()
  local total = 0
  local count = 0

  local f = assert(io.popen("sensors"))
  for line in f:lines() do
    local temp = line:match(re)
    if temp then
      total = total + tonumber(temp)
      count = count + 1
    end
  end
  f:close()

  if count == 0 then
    return 0
  end

  -- the range of value is 2200 to 5000 RPM
  -- we need to return a value between 0 and 100
  return math.floor((total / count - 2200) / (5000 - 2200) * 100)
end)
