-- init.lua
-- see `$VIMRUNTIME/example_init.lua`

---@param msg string Content of the notification to show to the user.
---@param level integer|nil One of the values from |vim.log.levels|.
---@param opts table|nil Optional parameters. Unused by default.
---@diagnostic disable-next-line
function vim.notify(msg, level, opts)
  local chunks = {
    {
      msg,
      level == vim.log.levels.DEBUG and 'Statement'
        or level == vim.log.levels.INFO and 'MoreMsg'
        or level == vim.log.levels.WARN and 'WarningMsg'
        or nil,
    },
  }
  vim.api.nvim_echo(chunks, true, { err = level == vim.log.levels.ERROR })
end

---@type 'netrw'|'snacks'|'oil'
vim.g.default_file_explorer = 'oil'

-- disable netrw if using another file explorer
vim.g.loaded_netrw = vim.g.default_file_explorer == 'netrw' and 1 or nil

--
if vim.is_callable(vim.pack.add) then
  vim.g.plug_home = vim.fs.joinpath(vim.fn.stdpath('data'), 'site', 'pack', 'core', 'opt')
end

vim.cmd('runtime vimrc')

vim.loader.enable()

-- try `:options`
vim.o.cmdheight = 0
vim.o.pumblend = 0
vim.o.winborder = 'rounded'

local require = require('meta').safe_require

-- use the new extui module if available
require('vim._extui').enable({})

local Plug = require('plug').Plug

Plug('nvim.snacks')

-- stylua: ignore start
_G.bt = function() Snacks.debug.backtrace() end
_G.ddd = function(...) return Snacks.debug.inspect(...) end
-- stylua: ignore end
vim.print = _G.ddd

Plug('nvim.colorscheme')
Plug('nvim.mini')
Plug('nvim.lsp')
Plug('nvim.treesitter')

_G.icons = require('nvim.icons')
_G.plugins = require('plugins')
_G.config = require('nvim.config')
