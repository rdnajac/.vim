local M = {}

local MAX_INSPECT_LINES = 2 ^ 10

local notify = function(...) Snacks.notify.warn(...) end

local function get_caller(skip_levels, predicate)
  for level = skip_levels or 2, 10 do
    local info = debug.getinfo(level, 'S')
    if info and info.what ~= 'C' and info.source ~= 'lua' then
      if not predicate or predicate(info) then
        return info
      end
    end
  end
end

local function format_source(source) return vim.fn.fnamemodify(source:sub(2), ':p:~:.') end

local function should_include_in_trace(info)
  return info
    and info.what ~= 'C'
    and info.source ~= 'lua'
    and not info.source:find('snacks[/\\]debug')
end

-- Show a notification with a pretty backtrace
---@param msg? string|string[]
---@param opts? snacks.notify.Opts
M.bt = function(msg, opts)
  opts = vim.tbl_extend('force', {
    level = vim.log.levels.WARN,
    title = 'Backtrace',
  }, opts or {})
  ---@type string[]
  local trace = type(msg) == 'table' and msg or type(msg) == 'string' and { msg } or {}
  for level = 2, 20 do
    local info = debug.getinfo(level, 'Sln')
    if should_include_in_trace(info) then
      local line = '- `' .. format_source(info.source) .. '`:' .. info.currentline
      if info.name then
        line = line .. ' _in_ **' .. info.name .. '**'
      end
      table.insert(trace, line)
    end
  end
  notify(#trace > 0 and (table.concat(trace, '\n')) or '', opts)
end

M.dd = function(...)
  local len = select('#', ...) ---@type number
  local obj = { ... } ---@type unknown[]
  local me = debug.getinfo(1, 'S')
  local caller = get_caller(
    2,
    function(info)
      return info.source ~= me.source and info.source ~= '@' .. (os.getenv('MYVIMRC') or '')
    end
  )
  vim.schedule(function()
    local lines = vim.split(vim.inspect(len == 1 and obj[1] or len > 0 and obj or nil), '\n')
    notify(lines, {
      title = 'Debug: ' .. format_source(caller.source) .. ':' .. caller.linedefined,
      ft = 'lua',
    })
  end)
end

-- Very simple function to profile a lua function.
-- * **flush**: set to `true` to use `jit.flush` in every iteration.
-- * **count**: defaults to 100
---@param fn fun()
---@param opts? {count?: number, flush?: boolean}
M.pp = function(fn, opts)
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

return M
