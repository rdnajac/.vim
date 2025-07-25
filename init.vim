runtime vimrc

set backup
set backupext=.bak
let &backupdir = stdpath('state') . '/backup//'
let &backupskip .= ',' . escape(expand('$HOME/.cache/*'), '\')
let &backupskip .= ',' . escape(expand('$HOME/.local/*'), '\')
set undofile

" let g:loaded_2html_plugin = 1
let g:loaded_gzip = 1
let g:loaded_matchit = 1
let g:loaded_netrwPlugin = 1
let g:loaded_tarPlugin = 1
let g:loaded_tutor_mode_plugin = 1
let g:loaded_zipPlugin = 1

function! s:settings()
  if !exists('$SSH_TTY') | set clipboard=unnamedplus | endif
  set jumpoptions=view,stack
  set mousescroll=hor:0
  set smoothscroll
  " disable the default popup menu
  aunmenu PopUp
  autocmd! nvim.popupmenu
endfunction

if v:vim_did_enter
  call s:settings()
else
  augroup init_lua
    autocmd!
    autocmd VimEnter * call s:settings()
  augroup END
endif

command! PackUpdate lua vim.pack.update()
packadd! vimline

lua require('init') -- ~/.config/nvim/lua/init.lua
lua require('nvim') -- ~/.config/nvim/lua/nvim/init.lua

let $MYVIMRC = fnamemodify(expand('$MYVIMRC'), ':h:p') . '/vimrc'
