--- init.lua
T1 = vim.uv.hrtime()
vim.loader.enable()

require('vim._core.ui2').enable({
  msg = { target = 'msg' },
})

vim.cmd([[ source ~/.vim/vimrc | colorscheme tokyonight ]])

require('snacks').setup({
  -- stylua: ignore
  dashboard = {
    enabled = vim.fn.argc(-1) == 0,
    preset = {
      keys = {
      { icon = '󰱼 ', desc = 'Files',   key = 'F', action = function() Snacks.picker.smart() end }, { section = 'recent_files', indent = 2 },
      { icon = ' ', desc = 'Health',  key = 'H', action = ':checkhealth' },
      { icon = '󰒲 ', desc = 'LazyGit', key = 'G', action = ':lua Snacks.lazygit()' },
      { icon = ' ', desc = 'Mason',   key = 'M', action = ':Mason' },
      { icon = ' ', desc = 'Update',  key = 'U', action = vim.pack.update },
      { icon = ' ', desc = 'News',    key = 'N', action = function() Snacks.zen({win = {file = vim.api.nvim_get_runtime_file('doc/news.txt', false)[1]}}) end },
      },
    },
    sections = {
      { section = 'header' },
      { section = 'keys' },
      { section = 'terminal', cmd = [[cowsay "The computing scientist's main challenge is not to get confused by the complexities of his own making"  | sed "s/^/        /" ]] },
      { section = 'startup' },
    },
  },
  explorer = { replace_netrw = true, trash = true },
  image = { enabled = true },
  indent = { indent = { only_current = false, only_scope = true } },
  input = { enabled = true },
  -- notifier = require('munchies.notifier'),
  quickfile = { enabled = true },
  picker = require('munchies.picker'),
  scope = { enabled = true },
  scroll = { enabled = true },
  -- statuscolumn = require('munchies.statuscolumn'),
  styles = { lazygit = { height = 0, width = 0 } },
  toggle = { which_key = false },
  words = { enabled = true },
})

_G.dd = Snacks.debug.inspect
_G.bt = Snacks.debug.backtrace
_G.p = Snacks.debug.profile

_G.nv = require('nvim')

T2 = vim.uv.hrtime()
-- vim: fdl=2
