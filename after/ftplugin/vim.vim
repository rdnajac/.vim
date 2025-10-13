setlocal commentstring=\"\ %s " add space after the comment character
setlocal iskeyword-=#         " makes autoloaded functions easier to `ciw`
setlocal formatoptions-=ro    " don't continue comments with 'o' or 'O'

nnoremap <leader>ch <Cmd>call edit#ch()<CR>

inoremap <buffer> enc scriptencoding utf-8

" Scriptease help and lsp hover collide
" leader K is normal! K but its hyperlink in markdown
nmap <silent><buffer> <localleader>K <Plug>ScripteaseHelp

" nnoremap <buffer> K <Cmd>lua vim.lsp.buf.hover()<CR>
" BUG: hover doesn't work on settings prefixed with 'no'
" and some settings like 'showcmdloc'
" this might be an issue with vimls itself
