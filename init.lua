--- init.lua
T1 = vim.uv.hrtime()
vim.loader.enable()

vim.cmd([[ 
source ~/.vim/vimrc 

command! News    :lua Snacks.zen({ win = { file = vim.api.nvim_get_runtime_file('doc/news.txt', false)[1] } })
command! Health  :packloadall | checkhealth
command! Update  :lua vim.pack.update()'
command! LazyGit :lua Snacks.lazygit()
]])

-- stylua: ignore
local dashkeys = {
  { action = ':News',    desc = 'News',    icon = ' ', key = 'N' },
  { action = ':Health',  desc = 'Health',  icon = ' ', key = 'H' },
  { action = ':Update',  desc = 'Update',  icon = ' ', key = 'U' },
  { action = ':Mason',   desc = 'Mason',   icon = ' ', key = 'M' },
  { action = ':LazyGit', desc = 'LazyGit', icon = '󰒲 ', key = 'G' },
}

require('snacks').setup({
  -- bigfile = { enabled = true },
  dashboard = {
    enabled = true,
    preset = { keys = dashkeys },
    sections = {
      { section = 'header' },
      { section = 'keys' },
      {
        title = 'Files',
        key = 'F',
        icon = '󰱼 ',
        action = function() Snacks.picker.files() end,
        { section = 'recent_files', indent = 2 },
      },
      {
        section = 'terminal',
        cmd = '$HOME/.vim/scripts/cowsay.sh',
        padding = 1,
      },
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

require('nvim')
T2 = vim.uv.hrtime()
