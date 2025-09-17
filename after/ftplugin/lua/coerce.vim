" vim global to `vim.g.%s =`
nnoremap crv 0d3wivim.g.<Esc>
" vim.g to `let g:%s =`
nnoremap crV 0d4wilet<Space>g:<Esc>

finish " XXX: WIP...

" `0`     (normal mode): start at the beginning of the line
" `<C-o>` (insert mode): execute the next normal mode command

" `local function fn(...)` --> `M.fn = function(...)`
nnoremap <buffer> crM <Cmd>normal! 0dwdiM.<C-O>w = <Esc>p<CR>
nnoremap <buffer> crM 0dwdiM.<C-o>w = <Esc>p

" and in the other direction...
nnoremap <buffer> crm 0dwdiwM.<C-o>w \<Space>=\<Space><Esc>p
