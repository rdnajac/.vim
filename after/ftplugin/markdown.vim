let g:markdown_fenced_languages = ['sh', 'cpp', 'python', 'vim', 'lua', 'r']
" let g:markdown_syntax_conceal = 1
" let g:markdown_folding        = 1

if executable('prettier')
  let &l:formatprg = 'prettier --stdin-filepath ' . expand('%:p')
endif

setlocal noautoindent
setlocal textwidth=80
setlocal formatoptions+=o 
setlocal commentstring=>\ %s

" Insert an octothorpe at the beginning of the line that already has text
nnoremap <buffer> <localleader>h ^i#<Space><Esc>
inoremap <buffer> <localleader>h <C-o>i#<Space>

inoremap <buffer> ``c ```cpp<CR><CR>```<Up>
inoremap <buffer> ``p ```python<CR><CR>```<Up>
inoremap <buffer> ``v ```vim<CR><CR>```<Up>
inoremap <buffer> `!  ```sh<CR><CR>```<Up>
inoremap <buffer> `$  ```console<CR><CR>```<Up>

inoremap <buffer> <! <!--<Space>--><Left><Left><Left><Left><Space>

vnoremap <leader>k :call hyperlink#()<CR>
