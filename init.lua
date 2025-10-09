vim.loader.enable()
vim.g.plug_dir = vim.fs.joinpath(vim.fn.stdpath('data'), 'site', 'pack', 'core', 'opt')
vim.g.lua_root = vim.fs.joinpath(vim.fn.stdpath('config'), 'lua')
-- TODO: merge with nv.stdpath

if vim.env.PROF then
  vim.opt.rtp:append(vim.fs.joinpath(vim.g.plug_dir, 'snacks.nvim'))
  require('snacks.profiler').startup({ startup = { event = 'UIEnter' } })
end

--- generates vim.g.plugins
--- plug#end calls vim.pack.add for those plugins
--- snacks is included in vim.g.plugins
--- run vimrc before requiring nvim so snacks is on the rtp
vim.cmd([[runtime vimrc]])

require('nvim')
