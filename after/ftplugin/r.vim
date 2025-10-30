" TODO: move to r.lua opts
setlocal iskeyword-=.

" Note that not all terminals handle these key presses the same way
inoremap <buffer> <M--> <-<Space>
inoremap <buffer> <M-Bslash> <Bar>><Space>
inoremap <buffer> <space><space> viw

" TODO: move to snippets
inoremap <buffer> ins<Tab> renv::install("")<Left><Left>
inoremap <buffer> lib<Tab> library()<Left>

" if has('nvim') && luaeval('package.loaded["r"] ~= nil')
setlocal keywordprg=:RHelp

autocmd BufEnter term://*:R\ * startinsert

nmap <buffer> zq <Cmd>RFormat<CR>

nnoremap <buffer> <localleader>R <Plug>RStart
nnoremap <buffer> ]r <Plug>NextRChunk
nnoremap <buffer> [r <Plug>PreviousRChunk
vnoremap <buffer> <CR> <Plug>RSendSelection
" nnoremap <buffer> <CR> <Plug>RDSendLine
nnoremap <buffer> <M-CR> <Plug>RInsertLineOutput

nnoremap <buffer> <localleader>r<CR> <Plug>RSendFile
nnoremap <buffer> <localleader>rq <Plug>RClose

nnoremap <buffer> <localleader>ry <Cmd>RSend Y<CR>
nnoremap <buffer> <localleader>ra <Cmd>RSend a<CR>
nnoremap <buffer> <localleader>rn <Cmd>RSend n<CR>
nnoremap <buffer> <localleader>rs <Cmd>RSend renv::status()<CR>
nnoremap <buffer> <localleader>rS <Cmd>RSend renv::snapshot()<CR>
nnoremap <buffer> <localleader>rr <Cmd>RSend renv::restore()<CR>

nnoremap <buffer> <localleader>rq :<C-U>RSend quarto::quarto_preview(file="<C-R>=expand('%:p')<CR>")<CR>

" TODO: are these overridden by R.nvim in after/ftplugin?
hi clear RCodeBlock
hi clear RCodeComment
" endif
