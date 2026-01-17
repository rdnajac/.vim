setlocal foldmethod=expr
setlocal foldexpr=v:lua.vim.treesitter.foldexpr()
setlocal iskeyword-=.
setlocal keywordprg=:RHelp

nmap <buffer> zq <Cmd>RFormat<CR>

inoremap <buffer> <M--> <-<Space>
inoremap <buffer> <M-Bslash> <Bar>><Space>

nnoremap <buffer> <localleader>R <Plug>RStart
nnoremap <buffer> ]r     <Plug>NextRChunk
nnoremap <buffer> [r     <Plug>PreviousRChunk
vnoremap <buffer> <CR>   <Plug>RSendSelection
nnoremap <buffer> <CR>   <Plug>RDSendLine
nnoremap <buffer> <M-CR> <Plug>RInsertLineOutput

nnoremap <buffer> <localleader>r<CR> <Plug>RSendFile
nnoremap <buffer> <localleader>rq    <Plug>RClose

nnoremap <buffer> <localleader>ry <Cmd>RSend Y<CR>
nnoremap <buffer> <localleader>ra <Cmd>RSend a<CR>
nnoremap <buffer> <localleader>rn <Cmd>RSend n<CR>
nnoremap <buffer> <localleader>rs <Cmd>RSend renv::status()<CR>
nnoremap <buffer> <localleader>rS <Cmd>RSend renv::snapshot()<CR>
nnoremap <buffer> <localleader>rr <Cmd>RSend renv::restore()<CR>

nnoremap <buffer> <localleader>rq :<C-U>RSend quarto::quarto_preview(file="<C-R>=expand('%:p')<CR>")<CR>

" hi clear RCodeBlock
" hi clear RCodeComment
