setlocal iskeyword-=.
setlocal formatexpr=

" FIXME: this adds unwanted text to the start of the file
" let &l:formatprg = "Rscript -e \"con <- file('stdin'); src <- readLines(con); close(con); cat(styler::style_text(src), sep = '\\n')\""

" Note that not all terminals handle these key presses the same way
inoremap <buffer> <M--> <-<Space>
inoremap <buffer> <M-Bslash> <Bar>><Space>

" TODO: move to snippets
inoremap <buffer> ins<Tab> renv::install("")<Left><Left>
inoremap <buffer> lib<Tab> library()<Left>

if has('nvim') && luaeval('package.loaded["r"] ~= nil')
  nnoremap <buffer> <localleader>R <Plug>RStart
  nnoremap <buffer> ]r <Plug>NextRChunk
  nnoremap <buffer> [r <Plug>PreviousRChunk
  vnoremap <buffer> <CR> <Plug>RSendSelection
  nnoremap <buffer> <CR> <Plug>RDSendLine
  nnoremap <buffer> <M-CR> <Plug>RInsertLineOutput

  nnoremap <buffer> <localleader>r<CR> <Plug>RSendFile
  nnoremap <buffer> <localleader>rq <Plug>RClose
  nnoremap <buffer> <localleader>rD <Plug>RSetwd

  nnoremap <buffer> <localleader>r? <Cmd>RSend getwd()<CR>
  nnoremap <buffer> <localleader>rR <Cmd>RSend source(".Rprofile")<CR>
  nnoremap <buffer> <localleader>rd <Cmd>RSend setwd(vim.fn.expand("<cword>"))<CR>
  nnoremap <buffer> <localleader>rs <Cmd>RSend renv::status()<CR>
  nnoremap <buffer> <localleader>rS <Cmd>RSend renv::snapshot()<CR>
  nnoremap <buffer> <localleader>rr <Cmd>RSend renv::restore()<CR>

  nnoremap <buffer> <localleader>rq :<C-U>RSend quarto::quarto_preview(file=expand('%:p'))<CR>

  " TODO: are these overridden by R.nvim in after/ftplugin?
  hi clear RCodeBlock
  hi clear RCodeComment
endif
