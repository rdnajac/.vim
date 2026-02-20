function! s:read_template(fname)
  " TODO: find templates relative to this script: <afile>?
  let fpath = stdpath('config') . '/templates/' . a:fname
  if filereadable(fpath)
    execute '0r ' . fpath
  endif
endfunction

augroup vimrc_template
  autocmd!
  autocmd BufReadPost *.template execute 'set filetype=' . fnamemodify(expand('<afile>'), ':p:t:r:e')
  autocmd BufNewFile */after/lsp/*.lua call <SID>read_template('lsp.lua.template')
  autocmd BufNewFile */lua/nvim/blink/sources/*.lua call <SID>read_template('blink-source.lua.template')
augroup END
