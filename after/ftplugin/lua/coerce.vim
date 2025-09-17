" vim global to `vim.g.%s =`
nnoremap crv ^d3wivim.g.<Esc>
" vim.g to `let g:%s =`
nnoremap crV ^d4wilet<Space>g:<Esc>

finish " XXX: WIP...

" `local function fn(...)` --> `M.fn = function(...)`
nnoremap <buffer> crM <Cmd>normal! 0dwdiM.<C-O>w = <Esc>p<CR>
nnoremap <buffer> crM 0dwdiM.<C-o>w = <Esc>p

" and in the other direction...
nnoremap <buffer> crm 0dwdiwM.<C-o>w \<Space>=\<Space><Esc>p
