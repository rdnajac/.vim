if !has('nvim')
  let g:markdown_fenced_languages = ['sh', 'cpp', 'python', 'vim', 'lua', 'r']
  " let g:markdown_syntax_conceal = 1
  " let g:markdown_folding        = 1
endif

if executable('prettier')
  let &l:formatprg = 'prettier --stdin-filepath ' . expand('%:p')
endif

" set up header abbreviations
call map(range(1, 6), {i, v ->
      \ execute(printf('ia <buffer> h%s %s', v, repeat('#', v)))})

setlocal noautoindent
setlocal textwidth=80
setlocal formatoptions+=o
setlocal commentstring=>\ %s

" maps `ic` and `ac` to select inner and outer code blocks
call textobjects#codeblock_map()

" Insert an octothorpe at the beginning of the line that already has text
nnoremap <buffer> <localleader>h ^i#<Space><Esc>
inoremap <buffer> <localleader>h <C-o>i#<Space>

inoremap <buffer> ``c ```cpp<CR><CR>```<Up>
inoremap <buffer> ``p ```python<CR><CR>```<Up>
inoremap <buffer> ``v ```vim<CR><CR>```<Up>
inoremap <buffer> ``l ```lua<CR><CR>```<Up>
inoremap <buffer> `!  ```sh<CR><CR>```<Up>
inoremap <buffer> `$  ```console<CR><CR>```<Up>

inoremap <buffer> <! <!--<Space>--><Left><Left><Left><Left><Space>

xnoremap <leader>k :call hyperlink#()<CR>

let b:surround_96 = "```\n\r\n```"

" move to the beginning of the line before dialing the header level
if exists('g:speeddating_handlers')
  nmap <buffer><expr> <C-a> (getline('.') =~# '^#' ? '<Home>' : '')..'<Plug>SpeedDatingUp'
  nmap <buffer><expr> <C-x> (getline('.') =~# '^#' ? '<Home>' : '')..'<Plug>SpeedDatingDown'
endif
