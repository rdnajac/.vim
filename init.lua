--- init.lua
T1 = vim.uv.hrtime()
vim.loader.enable()
_G.P = vim.print

require('nvim.ui.2')

vim.cmd([[
colorscheme tokyonight
source ~/.vim/vimrc
command! News exe 'e' nvim_get_runtime_file('doc/news.txt', v:false)[0]
" restart neovim and restore state with Session
nnoremap <D-r> <Cmd>exe 'mks!' stdpath('state')..'/Session.vim' \| exe 'conf restart sil so' v:this_session<CR>
" treesitter-incremental-selection
nmap <C-Space> van
xmap <C-Space> an

" snacks
xnoremap /  <Cmd>lua Snacks.picker.grep_word()<CR>
nnoremap ,. <Cmd>lua Snacks.scratch.open()<CR>

" delete around indent
nmap dI dai
nmap vI vai
inoremap <C-x><C-i> <Cmd>lua Snacks.picker.icons({ layout = require('munchies.layouts').insert })<CR>
]])

local shortcuts = {
  { icon = '󰱼 ', title = 'Files', { section = 'recent_files', indent = 2 } },
  { icon = ' ', desc = 'Health ', key = 'H', action = ':checkhealth' },
  { icon = '󰒲 ', desc = 'LazyGit', key = 'G', action = ':lua Snacks.lazygit()' },
  { icon = ' ', desc = 'Mason  ', key = 'M', action = ':Mason' },
  { icon = ' ', desc = 'News   ', key = 'N', action = ':News' },
  { icon = ' ', desc = 'Update ', key = 'U', action = ':lua vim.pack.update()' },
}

assert(require('snacks'))
Snacks.setup({
  dashboard = {
    preset = { keys = shortcuts },
    sections = {
      { section = 'header' },
      { section = 'keys' },
        -- stylua: ignore
        { section = 'terminal', cmd = [[cowsay "The computing scientist's main challenge is not to get confused by the complexities of his own making"  | sed "s/^/        /" ]] },
      function() return { footer = 'NVIM ' .. tostring(vim.version()), padding = 1 } end,
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

_G.Plug = require('plug')
_G.dd = require('snacks.debug')
_G.nv = vim
  .iter(vim.fn.readdir(vim.fn.stdpath('config') .. '/lua/nvim'))
  :map(function(filename)
    local modname = vim.fn.fnamemodify(filename, ':r')
    local ok, mod = xpcall(require, debug.traceback, 'nvim.' .. modname)
    if not ok then
      Snacks.notify.error(('Error `require()`ing: %s:\n%s'):format(modname, mod))
    end
    return modname, mod
  end)
  :fold({}, rawset)

Plug(require('plugins'))

nv.mini.init()
-- vim:fdl=1
