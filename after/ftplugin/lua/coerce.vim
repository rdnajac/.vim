finish " XXX: WIP...

" map to `cr` like with CoeRce from `vim-abolish`
" keymaps should work from anywhere on the
" local function transform
" function M.transform

" `0`     (normal mode): start at the beginning of the line
" `<C-o>` (insert mode): execute the next normal mode command

" `local function fn(...)` --> `M.fn = function(...)`
nnoremap <buffer> crM <Cmd>normal! 0dwdiM.<C-O>w = <Esc>p<CR>
nnoremap <buffer> crM 0dwdiM.<C-o>w = <Esc>p

" and in the other direction...
nnoremap <buffer> crm 0dwdiwM.<C-o>w \<Space>=\<Space><Esc>p
