let g:markdown_fenced_languages = ['sh', 'cpp', 'python', 'vim', 'lua', 'r']
" let g:markdown_syntax_conceal = 1
" let g:markdown_folding        = 1

if executable('prettier')
  let &l:formatprg = 'prettier --stdin-filepath ' . expand('%:p')
endif

setlocal formatoptions+=o
setlocal noautoindent
setlocal textwidth=80
" treat quoted text as comments for easy toggling
" setlocal commentstring=>\ %s

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

lua << EOF
vim.b.minisurround_config = {
  custom_surroundings = {
    -- Markdown link. Common usage:
    -- `saiwL` + [type/paste link] + <CR> - add link
    -- `sdL` - delete link
    -- `srLL` + [type/paste link] + <CR> - replace link
    L = {
      input = { '%[().-()%]%(.-%)' },
      output = function()
      local link = require('mini.surround').user_input('Link: ')
      return { left = '[', right = '](' .. link .. ')' }
      end,
    },
    },
  }
EOF
