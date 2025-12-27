vim.loader.enable()

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
  local plug_home = vim.g.plug_home or '/Users/rdn/.local/share/nvim/site/pack/core/opt'
  local snacks = plug_home .. '/snacks.nvim'
  vim.opt.rtp:append(snacks)

  ---@type snacks.profiler.Config
  local opts = {
    thresholds = {
      time = { 2, 10 },
      pct = { 10, 20 },
      count = { 10, 100 },
      ---@type table<string, snacks.profiler.Pick|fun():snacks.profiler.Pick?>
      presets = {
        startup = { min_time = 0.1, sort = false },
        on_stop = {},
        filter_by_plugin = function()
          return { filter = { def_plugin = vim.fn.input('Filter by plugin: ') } }
        end,
      },
    },
  }
  require('snacks.profiler').startup(opts)
end

vim.cmd.runtime('vimrc')
-- if vim.env.LAZY then return require('nvim.lazy').bootstrap() end
if vim.g.myplugins ~= nil then
  vim.pack.add(vim.g.myplugins)
end

vim.o.cmdheight = 0
vim.o.winborder = 'rounded'

require('vim._extui').enable({})

require('folke.snacks')
require('folke.tokyonight')
require('folke.which-key')
require('nvim')
require('nvim.mini')

vim.o.statuscolumn = '%!v:lua.nv.statuscolumn()'
