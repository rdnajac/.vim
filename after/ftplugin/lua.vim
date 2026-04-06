" let &l:formatprg = 'stylua --search-parent-directories --stdin-filepath=% -'
let &l:formatprg = 'stylua -f ~/.vim/stylua.toml --stdin-filepath=% -'

inoremap <buffer> `` vim.cmd([[]])<Left><Left><Left><C-g>u<CR><CR><esc>hi<Space><Space>

nnoremap <buffer> co2 O---@
nnoremap <buffer> coi O-- stylua:ignore

" autopairs
inoremap <buffer> {<Space> {}<Left>
inoremap <buffer> {<CR> {<CR>}<Esc>O
" inoremap <buffer> {, {<CR>},<C-c>O
inoremap <buffer> ( ()<Left>
inoremap <buffer> [[ [[]]<Left><Left>

" `tpope/vim-surround`
" NOTE: must use double quotes and the ascii values (e.g. i = 105)
let b:surround_85 = "function() \r end"
let b:surround_117 = "function()\n \r \nend"
let b:surround_105 = "-- stylua: ignore start\n \r \n--stylua: ignore end"
let b:surround_83 = "vim.schedule(function()\n \r \nend)"
