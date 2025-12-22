vim.cmd.runtime('vimrc')
-- Show a notification with a pretty printed dump of the object(s)
-- with lua treesitter highlighting and the location of the caller

-- local bit = require('bit')
-- local MAX_INSPECT_LINES = bit.lshift(2, 10)
local MAX_INSPECT_LINES = 2 ^ 10

-- TODO: move to a plugin witha register function that makes the _G functions
-- TODO: combine with any existing utility functions
_G.dd = function(...)
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

-- Show a notification with a pretty backtrace
---@param msg? string|string[]
---@param opts? snacks.notify.Opts
_G.bt = function(msg, opts)
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

-- stylua: ignore
_G.p = function(...) Snacks.debug.profile(...) end
-- _G.dd = function(...)
-- _G.bt = function(...)

if vim.env.PROF then
  vim.cmd.packadd('snacks.nvim')
  require('snacks.profiler').startup({})
end

if vim.env.LAZY then
  return require('nvim.lazy').bootstrap()
end

vim.pack.add(
  vim.tbl_map(function(plugin)
    return 'https://github.com/folke/' .. plugin .. '.nvim.git'
  end, { 'snacks', 'tokyonight', 'which-key' }),
  {
    load = function(data)
      vim.cmd.packadd({ data.spec.name, bang = true })
      require('nvim.folke.' .. data.spec.name:sub(1, -6))
    end,
  }
)

require('nvim')
