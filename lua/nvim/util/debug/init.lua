local M = {}

-- local bit = require('bit')
-- local MAX_INSPECT_LINES = bit.lshift(2, 10)
local MAX_INSPECT_LINES = 2 ^ 10

M.source = function()
  local me = debug.getinfo(1, 'S')
  -- .source:sub(2) when to sub? @...
  local dir = vim.fs.dirname(me.source:sub(2))

  local i = 1
  while true do
    i = i + 1
    -- info and (info.source == me.source or info.source == '@' .. vim.env.MYVIMRC or info.what ~= 'Lua')
    local info = debug.getinfo(i, 'S')
    if not info then
      error('Could not `debug.getinfo()`')
    end

    local src = info.source
    -- source = vim.uv.fs_realpath(source) or source
    src = src:sub(1, 1) == '@' and src:sub(2) or src
    if not vim.startswith(src, dir) then
      return vim.fs.abspath(src)
    end
  end
  return src .. ':' .. info.linedefined
end

-- Show a notification with a pretty backtrace
---@param msg? string|string[]
---@param opts? snacks.notify.Opts
M.bt = function(msg, opts)
  opts = vim.tbl_deep_extend('force', {
    level = vim.log.levels.WARN,
    title = 'Backtrace',
  }, opts or {})
  ---@type string[]
  local trace = type(msg) == 'table' and msg or type(msg) == 'string' and { msg } or {}
  for level = 2, 20 do
    local info = debug.getinfo(level, 'Sln')
    if
      info
      and info.what ~= 'C'
      and info.source ~= 'lua'
      and not info.source:find('snacks[/\\]debug')
    then
      local line = '- `'
        .. vim.fn.fnamemodify(info.source:sub(2), ':p:~:.')
        .. '`:'
        .. info.currentline
      if info.name then
        line = line .. ' _in_ **' .. info.name .. '**'
      end
      table.insert(trace, line)
    end
  end
  Snacks.notify(#trace > 0 and (table.concat(trace, '\n')) or '', opts)
end

M.dd = function(...)
  local len = select('#', ...) ---@type number
  local obj = { ... } ---@type unknown[]
  local caller = debug.getinfo(1, 'S')
  for level = 2, 10 do
    local info = debug.getinfo(level, 'S')
    if
      info
      and info.source ~= caller.source
      and info.what ~= 'C'
      and info.source ~= 'lua'
      and info.source ~= '@' .. (os.getenv('MYVIMRC') or '')
    then
      caller = info
      break
    end
  end
  vim.schedule(function()
    local title = 'Debug: '
      .. vim.fn.fnamemodify(caller.source:sub(2), ':~:.')
      .. ':'
      .. caller.linedefined
    local lines = vim.split(vim.inspect(len == 1 and obj[1] or len > 0 and obj or nil), '\n')
    if #lines > MAX_INSPECT_LINES then
      local c = #lines
      lines = vim.list_slice(lines, 1, MAX_INSPECT_LINES)
      lines[#lines + 1] = ''
      lines[#lines + 1] = (c - MAX_INSPECT_LINES) .. ' more lines have been truncated …'
    end
    Snacks.notify.warn(lines, { title = title, ft = 'lua' })
  end)
end

-- Very simple function to profile a lua function.
-- * **flush**: set to `true` to use `jit.flush` in every iteration.
-- * **count**: defaults to 100
---@param fn fun()
---@param opts? {count?: number, flush?: boolean, title?: string}
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
  Snacks.notify(
    ((uv.hrtime() - start) / 1e6 / opts.count) .. 'ms',
    { title = opts.title or 'Profile' }
  )
end

return M
