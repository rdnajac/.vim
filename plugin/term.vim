tnoremap <expr> <C-R> '<C-\><C-N>"'.nr2char(getchar()).'pi'

nnoremap <C-Bslash> <Cmd>lua Snacks.terminal.toggle()<CR>
tnoremap <C-Bslash> <Cmd>lua Snacks.terminal.toggle()<CR>

augroup vimrc_term
  " terminal stuff
  autocmd BufEnter term://*:R\ * startinsert
  autocmd BufEnter term://*/copilot startinsert
augroup END
