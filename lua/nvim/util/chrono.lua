--- Tracks the time spent in a function
--- @generic F: function
--- @param f F
--- @return F
local function track(stat, f)
  return function(...)
    local start = uv.hrtime()
    local r = { f(...) }
    stats[stat] = stats[stat] or { total = 0, time = 0 }
    stats[stat].total = stats[stat].total + 1
    stats[stat].time = stats[stat].time + uv.hrtime() - start
    return unpack(r, 1, table.maxn(r))
  end
end
