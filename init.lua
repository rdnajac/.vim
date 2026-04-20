--- init.lua
T1 = vim.uv.hrtime()
vim.loader.enable()
_G.pp = vim.print

require('nvim.ui.2')

vim.cmd([[ colorscheme tokyonight | source ~/.vim/vimrc ]])

require('snacks').setup({
  dashboard = {
    sections = {
      { section = 'header' },
      { icon = '󰱼 ', title = 'Files', { section = 'recent_files', indent = 2 } },
      { icon = ' ', desc = 'Health ', key = 'H', action = ':checkhealth' },
      { icon = '󰒲 ', desc = 'LazyGit', key = 'G', action = ':lua Snacks.lazygit()' },
      { icon = ' ', desc = 'Mason  ', key = 'M', action = ':Mason' },
      { icon = ' ', desc = 'News   ', key = 'N', action = ':News' },
      { icon = ' ', desc = 'Update ', key = 'U', action = ':lua vim.pack.update()' },
      -- {
      --   section = 'terminal',
      --   cmd = ('cowsay "%s"|sed "s/^/        /"'):format(
      --     'The computing scientist\'s main challenge is not to get confused by the complexities of his own making'
      --   ),
      -- },
      { footer = tostring(vim.version()) },
    },
  },
  explorer = { replace_netrw = true, trash = true },
  image = { enabled = true },
  indent = { indent = { only_current = false, only_scope = true } },
  input = { enabled = true },
  quickfile = { enabled = true },
  picker = require('munchies').picker,
  scope = { enabled = true },
  scroll = { enabled = true },
  words = { enabled = true },
})

_G.dd = Snacks.debug
_G.bt = dd.backtrace
_G.nv = vim
  .iter(vim.fn.readdir(vim.fn.stdpath('config') .. '/lua/nvim'))
  :map(function(fname) return vim.fn.fnamemodify(fname, ':r') end)
  :map(function(mname) return mname, require('nvim.' .. mname) end)
  :fold({}, rawset) -- inits an empty table and maps `nv[nvim.k] = v`

require('mason').setup()
