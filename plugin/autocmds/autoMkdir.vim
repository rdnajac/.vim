" autocmds/autoMkdir.vim
" Automatically create directories for new files

function! s:autoMkdir(file)
  if a:file =~# '^\w\+:[\\/][\\/]'
    return
  endif
  let l:file = resolve(expand(a:file)) ==# '' ? a:file : resolve(expand(a:file))
  let l:dir = fnamemodify(l:file, ':p:h')
  if !isdirectory(l:dir)
    call mkdir(l:dir, 'p')
  endif
endfunction

augroup autoMkdir
  autocmd!
  autocmd BufWritePre * call s:autoMkdir(expand('<afile>'))
augroup END
