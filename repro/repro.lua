-- Minimal `init.lua`: save as `repro.lua` and run with `nvim -u repro.lua`
local root = vim.fn.fnamemodify('./.repro', ':p')

for _, name in ipairs({ 'config', 'data', 'state', 'cache' }) do
  vim.env[('XDG_%s_HOME'):format(name:upper())] = root .. '/' .. name
end

local lazypath = root .. '/plugins/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({ 'git', 'clone', '--filter=blob:none', 'https://github.com/folke/lazy.nvim.git', lazypath })
end
vim.opt.runtimepath:prepend(lazypath)

local plugins = {
  { 'LazyVim/LazyVim', import = 'lazyvim.plugins' },
  -- add any other plugins here
}
require('lazy').setup(plugins, {
  root = root .. '/plugins',
})

vim.cmd.colorscheme('tokyonight')
-- add anything else here
