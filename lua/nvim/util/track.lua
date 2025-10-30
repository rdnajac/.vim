local M = {}

-- TODO:  split up logging and printing
--- log a message with timing info
---@param msg string
---@param store? table optional store (defaults to _G.t)
function M.log(msg, store)
  store = store or _G.t
  local now = vim.uv.hrtime()
  local time_since_t0 = (now - store[1]) / 1e6

  store[msg and msg or #store + 1] = time_since_t0

  local i = #store
  local prev = store[i - 1] and (store[i - 1] < store[1] and store[1] or store[i - 1]) or store[1]
  local diff = (now - prev) / 1e6

  -- Snacks.notify.warn(('%2d: %-16s (%7.3f) %+8.3f ms'):format(i, msg, abs, diff))
  -- Snacks.notify.warn(('%2d: %-16s %+8.3f ms'):format(i, msg or 'lap', diff))
end

setmetatable(_G.t, {
  __call = function(_, ...)
    return M.log(...)
  end,
})

--- @param ev table event data
require('nvim.util').lazyload(function(ev)
  t(ev.event)
end, { 'VimEnter', 'UIEnter', 'BufReadPost' })

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

-- --@alias LazyProfile {data: string|{[string]:string}, time: number, [number]:LazyProfile}
-- ---@type LazyProfile[]
-- M._profiles = { { name = "lazy" } }
-- ---@param data (string|{[string]:string})?
-- ---@param time number?
-- function M.track(data, time)
--   if data then
--     local entry = {
--       data = data,
--       time = time or vim.uv.hrtime(),
--     }
--     table.insert(M._profiles[#M._profiles], entry)
--
--     if not time then
--       table.insert(M._profiles, entry)
--     end
--     return entry
--   else
--     ---@type LazyProfile
--     local entry = table.remove(M._profiles)
--     entry.time = vim.uv.hrtime() - entry.time
--     return entry
--   end
-- end

return M
