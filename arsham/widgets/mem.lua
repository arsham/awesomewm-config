local helpers = require("vicious.helpers")

local mb = 1024 ^ 2

return helpers.setcall(function()
  local _mem = { buf = {}, swp = {} }

  for line in io.lines("/proc/meminfo") do
    for k, v in string.gmatch(line, "([%a]+):[%s]+([%d]+).+") do
      if k == "MemTotal" then
        _mem.total = v / mb
      elseif k == "MemFree" then
        _mem.buf.f = v / mb
      elseif k == "MemAvailable" then
        _mem.buf.a = v / mb
      elseif k == "Buffers" then
        _mem.buf.b = v / mb
      elseif k == "Cached" then
        _mem.buf.c = v / mb
      elseif k == "SwapTotal" then
        _mem.swp.t = v / mb
      elseif k == "SwapFree" then
        _mem.swp.f = v / mb
      end
    end
  end

  -- Calculate memory percentage
  _mem.free = _mem.buf.a
  _mem.inuse = _mem.total - _mem.free
  _mem.bcuse = _mem.total - _mem.buf.f
  _mem.usep = math.floor(_mem.inuse / _mem.total * 100)
  -- Calculate swap percentage
  _mem.swp.inuse = _mem.swp.t - _mem.swp.f
  _mem.swp.usep = math.floor(_mem.swp.inuse / _mem.swp.t * 100)

  return {
    _mem.usep,
    _mem.inuse,
    _mem.total,
    _mem.free,
    _mem.swp.usep,
    _mem.swp.inuse,
    _mem.swp.t,
    _mem.swp.f,
    _mem.bcuse,
  }
end)
