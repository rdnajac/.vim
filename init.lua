--- init.lua

--- optional LuaJIT profiling
--- `https://luajit.org/ext_profiler.html`
-- require('jit.p').start('ri1', '/tmp/prof')

--- overrides `loadfile()` and default nvim package loader
--- `https://github.com/neovim/neovim/discussions/36905`
vim.loader.enable()

--- `autoload/plug.vim` overrides vim-plug
--- `plug#end()` will `vim.pack.add` vim plugins
vim.cmd.source('vimrc')

-- ~/.local/share/nvim/site/pack/core/opt/snacks.nvim/lua/snacks/debug.lua:197
-- function M.backtrace(msg, opts)
function _G.bt()
  ---@type string[]
  local trace = {}
  for level = 1, 20 do
    local info = debug.getinfo(level, 'Sln')
    if not info then
      break
    elseif info.what ~= 'C' then
      local line = ('--- `%s:%s`%s'):format(
        vim.fn.fnamemodify(info.source:gsub('^@', ''), ':~:.'),
        info.currentline,
        info.name and ' _in_ **' .. info.name .. '**' or ''
      )
      table.insert(trace, line)
    end
  end
  return table.concat(trace, '\n')
end

-- ~/.local/share/nvim/site/pack/core/opt/snacks.nvim/lua/snacks/debug.lua:38
_G.dd = function(...)
  local len = select('#', ...) ---@type number
  local obj = { ... } ---@type unknown[]
  local trace = bt()
  vim.schedule(function() vim.print(trace, len == 1 and obj[1] or obj or nil) end)
end

if vim.env.PROF then
  vim.opt.rtp:append(vim.fn.stdpath('data') .. '/site/pack/core/opt/snacks.nvim')
  require('snacks.profiler').startup({ startup = { event = 'UIEnter' } })
end

_G.nv = require('nvim')
-- require('jit.p').stop()
