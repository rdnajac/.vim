local util = require('nvim.util')
local uv = vim.uv
-- local stats = {}
local M = {}
--- From vim.loader
--- Tracks the time spent in a function
--- @generic F: function
--- @param f F
--- @return F
M.track_fn = function(stat, f)
  return function(...)
    local start = uv.hrtime()
    local r = { f(...) }
    local stop = uv.hrtime()
    -- stats[stat] = stats[stat] or { total = 0, time = 0 }
    -- stats[stat].total = stats[stat].total + 1
    -- stats[stat].time = stats[stat].time + uv.hrtime() - start
    print(('%2d: %-12s(%7.3f) %7.3f'):format(stats[stat].total, stat, elapsed(1), elapsed(i)))
    return unpack(r, 1, table.maxn(r))
  end
end

-- TODO: work this into custom vim.notify
--- Track time taken with global list of timestamps
M.track = function(msg, fn)
  -- TODO: make sure _G.t exists and is a list
  -- TODO:  log time before/after fn?
  if vim.is_callable(fn) then
    fn()
  end

  local i = #_G.t
  _G.t[i + 1] = uv.hrtime()

  local function elapsed(idx)
    return (_G.t[#_G.t] - _G.t[idx]) / 1e6
  end

  print(('%2d: %-24s(%7.3f) %7.3f'):format(i, msg, elapsed(1), elapsed(i)))
end

--- @param ev table
util.lazyload(function(ev)
  track(ev.event)
end, { 'BufWinEnter', 'VimEnter', 'UIEnter' })

return track
