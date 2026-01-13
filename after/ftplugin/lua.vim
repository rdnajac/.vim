" let &l:formatprg = 'stylua --search-parent-directories --stdin-filepath=% -'
let &l:formatprg = 'stylua -f ~/.vim/stylua.toml --stdin-filepath=% -'

setlocal nowrap
setlocal comments=:---\ "
" setlocal nonumber signcolumn=yes:1
setlocal foldtext=v:lua.nv.foldtext()
setlocal foldmethod=expr

iabbrev <buffer> fu function()
inoremap <buffer> \fu function() end,<Esc>gEa<Space>
inoremap <buffer> \ig --<SPACE>stylua:<SPACE>ignore
inoremap <buffer> `` vim.cmd([[]])<Left><Left><Left><C-g>u<CR><CR><esc>hi<Space><Space>

" custom surround using `tpope/vim-surround`
" use ascii value (i = 105)
" NOTE: must use double quotes
let b:surround_85 = "function() \r end"
let b:surround_117 = "function()\n \r \nend"
let b:surround_105 = "-- stylua: ignore start\n \r \n--stylua: ignore end"
let b:surround_115 = "vim.schedule(function()\n \r \nend)"

" coerce
" vim global to `vim.g.%s =`
nnoremap crv ^d3wivim.g.<Esc>
" `vim.g.%s` to `let g:%s =`
nnoremap crV ^df4wilet<Space>g:<Esc>
