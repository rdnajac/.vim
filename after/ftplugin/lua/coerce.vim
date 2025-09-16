" WIP.. TODO: map to `cr` like with CoeRce from `vim-abolish`
" also see `../ftplugin/lua/coerce.lua
" local function transform

" `CoeRce` - change `local` to `M` and back (normal mode)
" keymaps work from anywhere on the line as long as the
" entire line is formatted consistently

" some important notes:
" 0 - start at the beginning of the line
" <C-O> - from insert mode, execute the next normal mode command

" `local function fn(...)` --> `M.fn = function(...)`
nnoremap <buffer> crM <Cmd>normal! 0dwdiM.<C-O>w = <Esc>p<CR>
nnoremap <buffer> crM 0dwdiM.<C-o>w = <Esc>p

" and in the other direction...
nnoremap <buffer> crm 0dwdiwM.<C-o>w \<Space>=\<Space><Esc>p
