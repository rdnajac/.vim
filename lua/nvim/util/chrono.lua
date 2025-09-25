--- Tracks the time spent in a function
--- @generic F: function
--- @param f F
--- @return F
local function track1(stat, f)
  return function(...)
    local start = uv.hrtime()
    local r = { f(...) }
    stats[stat] = stats[stat] or { total = 0, time = 0 }
    stats[stat].total = stats[stat].total + 1
    stats[stat].time = stats[stat].time + uv.hrtime() - start
    return unpack(r, 1, table.maxn(r))
  end
end

local function track2(fn)
  local t1 = vim.uv.hrtime()
  local ok, res = pcall(fn)
  local t2 = vim.uv.hrtime()
  local dt = (t2 - t1) / 1e6
  vim.notify(string.format('Elapsed time: %.2f ms', dt), vim.log.levels.INFO, {
    title = 'nvim.util.track',
  })
  if not ok then
    error(res)
  end
  return res
end

-- TODO: work this into custom vim.notify
local track = function(msg, fn)
  -- TODO: make sure _G.t exists and is a list
  -- TODO:  log time before/after fn?
  if vim.is_callable(fn) then
    fn()
  end

  local i = #_G.t
  _G.t[i + 1] = vim.uv.hrtime()

  local function elapsed(idx)
    return (_G.t[#_G.t] - _G.t[idx]) / 1e6
  end

  print(('%2d: %-24s(%7.3f) %7.3f'):format(i, msg, elapsed(1), elapsed(i)))
end

require('nvim.util').lazyload(function(ev)
  track(ev.event)
end, { 'BufWinEnter', 'VimEnter', 'UIEnter' })

return track
