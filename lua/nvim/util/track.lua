_G.t = _G.t or { vim.uv.hrtime() }

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

vim.api.nvim_create_autocmd({ 'VimEnter', 'UIEnter', 'BufReadPost' }, {
  callback = function(ev)
    t(ev.event)
  end,
  once = true,
})

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

M.write_log = function()
  vim.api.nvim_create_autocmd('VimEnter', {
    callback = function()
      local startuptime = _G.t[1]
      local state = vim.loader.enabled and 'enabled' or 'disabled'
      local logpath = vim.fs.joinpath(vim.fn.stdpath('data'), 'startuptime.log')
      local stats = setmetatable({ total = 0, cnt = 0, high = 0, low = math.huge }, {
        __index = function(t, k)
          if k == 'avg' then
            return t.cnt > 0 and t.total / t.cnt or 0
          else
            return rawget(t, k)
          end
        end,
        __call = function(t, time)
          t.cnt = t.cnt + 1
          t.total = t.total + time
          t.high = math.max(t.high, time)
          t.low = math.min(t.low, time)
        end,
      })

      -- Read previous log and accumulate only current state
      if vim.uv.fs_stat(logpath) then
        for line in io.lines(logpath) do
          local ts, s, t, a = line:match('^(%d+),(%w+),([%d%.]+),([%d%.]+)$')
          if ts and s == state and t then
            stats(tonumber(t))
          end
        end
      end

      stats(startuptime)

      local f = io.open(logpath, 'a+')
      if f then
        f:write(('%d,%s,%.6f,%.6f\n'):format(os.time(), state, startuptime, stats.avg))
        f:close()
      end
    end,
  })
end

M.notify = function()
  local stats = {} -- placeholder
  local msg = table.concat({
    ('**vim.loader [%s]**'):format(stats.info),
    '',
    '| Metric | Value    |',
    '|--------|----------|',
    ('| Start  | %.2fms |'):format(stats.start),
    ('| Avg    | %.2fms |'):format(stats.avg),
    ('| High   | %.2fms |'):format(stats.high),
    ('| Low    | %.2fms |'):format(stats.low),
    ('| Runs   | %d       |'):format(stats.cnt),
  }, '\n')

  Snacks.notify.info(msg, { title = 'Startup Time', ft = 'markdown' })
end

return M
