setlocal foldmethod=expr foldtext=fold#text_lua()
" let &l:formatprg = 'stylua --search-parent-directories --stdin-filepath=% -'
let &l:formatprg = 'stylua -f ~/.vim/stylua.toml --stdin-filepath=% -'

inoremap <buffer> `` vim.cmd([[]])<Left><Left><Left><C-g>u<CR><CR><esc>hi<Space><Space>

nnoremap <buffer> co2 O---@
nnoremap <buffer> coi O-- stylua:<Space>ignore

" autopairs
inoremap <buffer> {<Space> {}<Left>
inoremap <buffer> {<CR> {<CR>}<Esc>O
inoremap <buffer> [[ [[]]<Left><Left>

nnoremap <buffer> yu <Cmd>call debug#print#lua()<CR>
nnoremap <buffer> ym <Cmd>call <SID>yankmod()<CR>

function! s:yankmod() abort
  let modname = fnamemodify(expand('%'), ':r:s?^.*/lua/??:s?/init$??')
  let line = printf("require('%s')", modname)
  call setreg('*', line)
  echo '[yanked] ' . line
endfunction

" `tpope/vim-surround`
" NOTE: must use double quotes and the ascii values (e.g. i = 105)
let b:surround_85 = "function() \r end"
let b:surround_117 = "function()\n \r \nend"
let b:surround_105 = "-- stylua: ignore start\n \r \n--stylua: ignore end"
let b:surround_83 = "vim.schedule(function()\n \r \nend)"
