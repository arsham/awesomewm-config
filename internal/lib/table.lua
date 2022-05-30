local function tbl_deep_clone(t)
  local t2 = {}
  for k, v in pairs(t) do
    if type(v) == "table" then
      t2[k] = tbl_deep_clone(v)
    else
      t2[k] = v
    end
  end
  return t2
end

---tbl_extend returns a new table that contains all the elements of the given
-- tables. If an element in t1 exists in t2, it will be replaced by the element
-- in t2. If an element is a table, it will be recursively merged. Neither of t1
-- and t2 are modified.
local function tbl_extend(t1, t2)
  if t1 == nil then
    return t2
  end
  local t = tbl_deep_clone(t1)
  for k, v in pairs(t2) do
    if type(v) == "table" then
      t[k] = tbl_extend(t[k], v)
    else
      t[k] = v
    end
  end
  return t
end

---Returns the index of the v in t if found. Otherwise returns -1.
local function find(t, v)
  for i, e in ipairs(t) do
    if e == v then
      return i
    end
  end
  return -1
end

return {
  tbl_extend = tbl_extend,
  find = find,
}
