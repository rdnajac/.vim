" make sure there's a space after the comment character
setlocal commentstring=\"\ %s

setlocal iskeyword-=#
setlocal formatoptions -=ro

nnoremap <leader>ch <Cmd>call edit#ch()<CR>

inoremap <buffer> \enc scriptencoding=utf-8

" Scriptease help and lsp hover collide
nmap <silent><buffer> <leader>K <Plug>ScripteaseHelp

" nnoremap <buffer> K <Cmd>lua vim.lsp.buf.hover()<CR>
" hover doesn't work on settings prefixed with 'no'
" and some settings like 'showcmdloc'
" this might be an issue with vimls itself
