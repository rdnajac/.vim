--- init.lua
T1 = vim.uv.hrtime()
vim.loader.enable()

vim.o.cmdheight = 0
require('vim._core.ui2').enable({
  msg = { target = 'msg' },
})

vim.cmd([[
source ~/.vim/vimrc
nnoremap <M-r> <Cmd>exe 'mks!' stdpath('state')..'/Session.vim' \| exe 'conf restart sil so' v:this_session<CR>
xnoremap /     <Cmd>lua Snacks.picker.grep_word()<CR>
nnoremap ,,    <Cmd>lua Snacks.picker.buffers()<CR>
nnoremap ,.    <Cmd>lua Snacks.scratch<CR>
inoremap <silent> <C-x><C-i> <Cmd>lua Snacks.picker.icons()<CR>
au FileType snacks_dashboard lua vim.schedule(function() vim.cmd('doautocmd ColorScheme') end)
]])

require('snacks').setup({
  dashboard = {
    enabled = vim.fn.argc(-1) == 0,
    preset = {
      -- stylua: ignore
      keys = {
	{ icon = '󰱼 ', desc = 'Files', key   = 'F', action = function() Snacks.picker.smart() end },
          { section = 'recent_files', indent = 2 },
	{ icon = ' ', desc = 'Mason', key   = 'M', action = ':Mason' },
	{ icon = '󰒲 ', desc = 'LazyGit', key = 'G', action = ':lua Snacks.lazygit()' },
	{ icon = ' ', desc = 'Update', key  = 'U', action = vim.pack.update },
	{ icon = ' ', desc = 'Health', key  = 'H', action = ':checkhealth' },
	{ icon = ' ', desc = 'News', key    = 'N', action = function() Snacks.zen({win = {file = vim.api.nvim_get_runtime_file('doc/news.txt', false)[1]}}) end },
      },
    },
    sections = {
      { section = 'header' },
      { section = 'keys' },
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

_G.nv = require('nvim')

nv.ui.colorscheme.init()
T2 = vim.uv.hrtime()
