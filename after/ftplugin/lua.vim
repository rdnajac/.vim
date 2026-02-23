" let &l:formatprg = 'stylua --search-parent-directories --stdin-filepath=% -'
let &l:formatprg = 'stylua -f ~/.vim/stylua.toml --stdin-filepath=% -'

setlocal nowrap           " don't wrap lines
setlocal formatoptions-=o " don't continue comments with `o`

iabbrev <buffer> fu function()
inoremap <buffer> \fu function() end,<Esc>gEa<Space>
inoremap <buffer> \ig --<SPACE>stylua:<SPACE>ignore
inoremap <buffer> `` vim.cmd([[]])<Left><Left><Left><C-g>u<CR><CR><esc>hi<Space><Space>

" `tpope/vim-surround`
" use ascii value (e.g. i = 105)
" NOTE: must use double quotes
if exists("g:loaded_surround") && g:loaded_surround == 1
  let b:surround_85 = "function() \r end"
  let b:surround_117 = "function()\n \r \nend"
  let b:surround_105 = "-- stylua: ignore start\n \r \n--stylua: ignore end"
  let b:surround_115 = "vim.schedule(function()\n \r \nend)"
endif
