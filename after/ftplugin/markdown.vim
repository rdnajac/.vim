" after/ftplugin/markdown.vim
let g:markdown_fenced_languages = ['sh', 'cpp', 'python', 'vim', 'lua', 'r']

if executable('prettier')
  let &l:formatprg = 'prettier --stdin-filepath ' . expand('%:p')
endif

setlocal formatoptions+=ro

setlocal textwidth=80
setlocal noautoindent
setlocal conceallevel=1

" treat quoted text as comments for easy toggling
setlocal commentstring=>\ %s


hi RenderMarkdownCode guibg=NONE
nmap <leader>k v:lua require('nvim.util.link').linkify()

" make selection **bold**
vmap <buffer> <C-b> S*vi*S*

" Insert an octothorpe at the beginning of the line that already has text
nnoremap <buffer> <localleader>h ^i#<Space><Esc>
inoremap <buffer> <localleader>h <C-o>i#<Space>

inoremap <buffer> ```c ```cpp<CR><CR>```<Up>
inoremap <buffer> ```p ```python<CR><CR>```<Up>
inoremap <buffer> ```v ```vim<CR><CR>```<Up>

ia <buffer> `c ```cpp<CR><CR>```<Up>

" stdin
inoremap <buffer> `! ```sh<CR><CR>```<Up>
" stdout
inoremap <buffer> `$ ```console<CR><CR>```<Up>

inoremap <buffer> <! <!--<Space>--><Left><Left><Left><Left><Space>

" let g:markdown_syntax_conceal = 1
" let g:markdown_folding        = 1
" call greek#setupmappings()
