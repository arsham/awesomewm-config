---Retuens a new string with additional spaces before the str, so it would be
--equal or more than n.
local function left_pad_to(n, str)
  local spaces = n - #str
  if spaces < 0 then
    return str
  end
  return string.rep(" ", spaces) .. str
end

return {
  left_pad_to = left_pad_to,
}
