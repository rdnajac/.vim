setlocal foldmethod=expr
setlocal foldtext=fold#text_lua()
" setlocal foldtext=v:vim.lsp.foldtext()

inoremap <buffer> `` vim.cmd([[]])<Left><Left><Left><C-g>u<CR><CR><esc>hi<Space><Space>

nnoremap <buffer> co2 O---@
nnoremap <buffer> coi O-- stylua:<Space>ignore

" autopairs
inoremap <buffer> {<Space> {}<Left>
inoremap <buffer> {<CR> {<CR>}<Esc>O
inoremap <buffer> [[ [[]]<Left><Left>

nnoremap <buffer> yu <Cmd>call debug#print#lua()<CR>
nnoremap <buffer> ym <Cmd>call <SID>yankmod()<CR>
nnoremap <buffer> yM <Cmd>call <SID>yankmod('.'..expand('<cword>')..'()')<CR>

function! s:yankmod(...) abort
  let modname = expand('%:r:s?^.*/lua/??:s?/init$??')
  let l = printf("require('%s')%s", modname, a:0 ? a:1 : '')
  call setreg('*', l)
  echo '[yanked] '..l
endfunction

" NOTE: must use double quotes for `vim-surround`
let s:surround_defs = {
      \ 'U': ['function() ',     ' end'],
      \ 'u': ["function()\n ", " \nend"],
      \ 'i': ["-- stylua: ignore start\n",  "\n--stylua: ignore end"],
      \ 'S': ["vim.schedule(function()\n ", "\nend)"],
      \ }

" define the table unconditionallhy here
let b:minisurround_config = { 'custom_surroundings': {} }
" it should have the inside custom surrounds and the s defined already
let b:minisurround_config.custom_surroundings = {
      \ 's': {
      \ 'input': ['%[%[().-()%]%]'], 'output': { 'left': '[[', 'right': ']]' },
      \   },
      \ }

" TODO: test!!!
for [key, pair] in items(s:surround_defs)
  " `let b:surround_105 = "-- stylua: ignore start\n\r\n--stylua: ignore end"`
  execute printf('let b:surround_%d = %s', char2nr(key), string(join(pair, "\r")))
  let b:minisurround_config.custom_surroundings[key] = {
        \ 'output': { 'left': pair[0], 'right': pair[1] },
        \ }
endfor
