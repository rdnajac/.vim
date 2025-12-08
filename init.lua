vim.loader.enable()

---@diagnostic disable-next-line: duplicate-set-field
function vim.print(...)
  return vim._print(true, ...)
end

vim.g.stdpath = vim.iter({ 'cache', 'config', 'data', 'state' }):fold({}, function(stdpath, d)
  stdpath[d] = vim.fn.stdpath(d)
  return stdpath
end)
-- vim.print(vim.g.stdpath)

vim.api.nvim_create_user_command('Restart', function()
  local sesh = vim.fn.fnameescape(vim.g.stdpath.state) .. '/Session.vim'
  vim.cmd([[mksession! ]] .. sesh)
  vim.cmd([[confirm restart silent source ]] .. sesh)
end, {})

vim.g.plug_home = vim.fs.joinpath(vim.g.stdpath.data, 'site', 'pack', 'core', 'opt')
vim.g.loaded_netrw = false

if vim.env.PROF then
  vim.opt.rtp:append(vim.fs.joinpath(vim.g.plug_home, 'snacks.nvim'))
  require('snacks.profiler').startup({
    -- startup = { event = 'UIEnter' },
  })
end

vim.cmd.runtime('vimrc')

require('nvim')
