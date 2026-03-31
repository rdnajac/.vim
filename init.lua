--- init.lua
T1 = vim.uv.hrtime()
vim.loader.enable()

vim.o.cmdheight = 0
require('vim._core.ui2').enable({
  msg = { target = 'msg' },
})

vim.cmd([[
source ~/.vim/vimrc
" color scheme
command! Health packloadall | checkhealth
command! Update lua vim.pack.update()
command! LazyGit lua Snacks.lazygit()
command! News    lua Snacks.zen({ win = { file = vim.api.nvim_get_runtime_file('doc/news.txt', false)[1] } })
command! -bang Scratch exe printf('lua Snacks%s.scratch()', <bang>0 ? '.profiler' : '')
command! R exe 'mks!' stdpath('state')..'/Session.vim' | exe 'conf restart sil so' v:this_session

command! Autocmds lua Snacks.picker.Autocmds()
command! Colorschemes lua Snacks.picker.Colorschemes()
" command! CommandHistory lua Snacks.picker.CommandHistory()
" command! Commands lua Snacks.picker.Commands()
" command! Diagnostics lua Snacks.picker.Diagnostics()
" command! DiagnosticsBuffer lua Snacks.picker.DiagnosticsBuffer()
command! Explorer lua Snacks.picker.Explorer()
command! Files lua Snacks.picker.Files()
command! Help lua Snacks.picker.Help()
command! Highlights lua Snacks.picker.Highlights()
command! Keymaps lua Snacks.picker.Keymaps()
command! Lines lua Snacks.picker.Lines()
command! Pickers lua Snacks.picker.Pickers()
command! Recent lua Snacks.picker.Recent()
command! Tags lua Snacks.picker.Tags()
command! Treesitter lua Snacks.picker.Treesitter()
command! Zoxide lua Snacks.picker.Zoxide()

inoremap <silent> <C-x><C-i> <Cmd>lua Snacks.picker.icons()<CR>

xnoremap /      <Cmd>lua Snacks.picker.grep_word()<CR>
nnoremap ,,     <Cmd>lua Snacks.picker.buffers()<CR>
nnoremap <Home> <Cmd>lua Snacks.dashboard.open()<CR>
nnoremap <M-`>  <Cmd>lua Snacks.dashboard.open()<CR>
nnoremap <M-r>  <Cmd>R<CR>
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
  dashboard = {
    -- enabled = tonumber(vim.g.dashboard) ~= 0,
    preset = { keys = dashkeys },
    sections = {
      { section = 'header' },
      { section = 'keys' },
      {
        title = 'Files',
        key = 'F',
        icon = '󰱼 ',
        action = function() Snacks.picker.smart() end,
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
_G.nv = vim
  .iter(ipairs({ 'ui', 'fs', 'keys', 'lsp', 'treesitter' }))
  :map(function(_, mod) return mod, require('nvim.' .. mod) end)
  :fold(require('nvim.util'), rawset)

T2 = vim.uv.hrtime()
Plug(nv.ui.colorscheme)
-- print('set colorscheme in ' .. (vim.uv.hrtime() - T2) / 1e6 .. 'ms')
