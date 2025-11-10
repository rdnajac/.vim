function! s:read_template(fname)
  let l:fpath = stdpath('config') . '/templates/' . a:fname
  if filereadable(l:fpath)
    execute '0r ' . l:fpath
  endif
endfunction

augroup lsp_template
  autocmd!
  autocmd BufReadPost *.template execute 'set filetype=' . fnamemodify(expand('<afile>'), ':p:t:r:e')
  autocmd BufNewFile */after/lsp/*.lua call <SID>read_template('lsp.lua.template')
  autocmd BufNewFile */lua/nvim/blink/sources/*.lua call <SID>read_template('blink-source.lua.template')
augroup END
