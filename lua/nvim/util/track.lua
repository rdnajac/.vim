-- _G.t = { vim.uv.hrtime() }
local M = {}

--- log a message with timing info
---@param msg string
---@param store? table optional store (defaults to _G.t)
function M.log(store, msg)
  store = store or _G.t
  local now = vim.uv.hrtime()
  local i = #store
  local prev = store[i]
  table.insert(store, now)

  local abs = (now - store[1]) / 1e6
  local diff = (now - prev) / 1e6

  print(('%2d: %-16s (%7.3f) %+8.3f ms'):format(i, msg, abs, diff))
end

--- Wrap a function so it logs when called
---@param label string
---@param fn function
---@param store? table
function M.track_fn(label, fn, store)
  return function(...)
    local ok, result = pcall(fn, ...)
    if ok then
      M.log(label, store)
      return result
    else
      error(result)
    end
  end
end
---
--- Wrap a function to measure execution time and log it
---@generic F: function
---@param label string
---@param fn F
---@return F
function M.track_complex_fn(label, fn)
  return function(...)
    local t0 = vim.uv.hrtime()
    local results = { fn(...) }
    local dur = (vim.uv.hrtime() - t0) / 1e6
    print(('%s took %.3f ms'):format(label, dur))
    return table.unpack(results, 1, #results)
  end
end

-- setmetatable(_G.t, { __call = require('nvim.util.track').log })
-- nv.lazyload(function(ev) t(ev.event) end, { 'BufWinEnter', 'VimEnter', 'UIEnter' })

return M
