local function _dump(o)
  if type(o) == "table" then
    local s = "{ "
    for k, v in pairs(o) do
      if type(k) == "function" then
        k = "function()"
      elseif type(k) ~= "number" then
        k = '"' .. k .. '"'
      else
      end
      s = s .. "[" .. k .. "] = " .. _dump(v) .. ","
    end
    return s .. "} "
  else
    return tostring(o)
  end
end

local function dump_str(...)
  local ret = {}
  for _, v in ipairs({ ... }) do
    table.insert(ret, _dump(v))
  end
  return table.concat(ret, " ")
end

local function dump(...)
  print(dump_str(...))
end

local function dump_to(file, ...)
  file = file or "/home/arsham/tmp/log.txt"
  file = io.open(file, "a+")
  local ret = {}
  for _, v in ipairs({ ... }) do
    table.insert(ret, _dump(v))
  end
  file:write(table.concat(ret, " ") .. "\n\n")
  file:close()
end

return {
  dump = dump,
  dump_to = dump_to,
  dump_str = dump_str,
}
