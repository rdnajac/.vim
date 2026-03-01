local M = {}

-- local me = debug.getinfo(1, 'S').source:gsub('^@', '')

M.bt = function()
  local trace = {} ---@type string[]
  for level = 2, 20 do -- arbitrary max depth
    local info = debug.getinfo(level, 'Sln')
    if not info then
      break
    elseif info.what ~= 'C' and info.source ~= '@' .. os.getenv('MYVIMRC') then
      local line = ('\n--- `%s:%s`%s'):format(
        vim.fn.fnamemodify(info.source, ':s/^@//:~:.'),
        info.currentline,
        info.name and ' _in_ **' .. info.name .. '**' or ''
      )
      table.insert(trace, line)
    end
  end
  return table.concat(trace, '\n')
end

local notify = vim.print
-- local notify = function(...) Snacks and Snacks.notify.warn(...) or vim.print(...) end

-- Very simple function to profile a lua function.
-- * **flush**: set to `true` to use `jit.flush` in every iteration.
-- * **count**: defaults to 100
---@param fn fun()
---@param opts? {count?: number, flush?: boolean}
M.profile = function(fn, opts)
  opts = vim.tbl_extend('force', { count = 100, flush = true }, opts or {})
  local uv = vim.uv
  local start = uv.hrtime()
  for _ = 1, opts.count, 1 do
    if opts.flush then
      jit.flush(fn, true)
    end
    fn()
  end
  notify(((uv.hrtime() - start) / 1e6 / opts.count) .. 'ms', { title = 'Profile' })
end

local aug = vim.api.nvim_create_augroup('audebug', {})

--- @param event vim.api.keyset.events|vim.api.keyset.events[]
--- @param pattern? string|string[]
--- @param cb? fun(ev:vim.api.keyset.create_autocmd.callback_args)
M.audebug = function(event, pattern, cb)
  return vim.api.nvim_create_autocmd(event, {
    group = aug,
    pattern = type(pattern) == 'string' and pattern or '*',
    callback = vim.is_callable(cb) and cb or _G.dd,
  })
end

-- count keys used in all subtables
M.key_counts = function(t)
  local ret = {}
  for _, v in pairs(t) do
    if type(v) == 'table' then
      for key in pairs(v) do
        ret[key] = (ret[key] or 0) + 1
      end
    end
  end
  return ret
end

return M
