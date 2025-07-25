" wrap gf to not open in the floating window
function! s:gf()
  let l:file = expand('<cfile>')
  if l:file == ''
    return
  endif
  wincmd w
  execute 'edit' fnameescape(l:file)
endfunction

nnoremap <buffer> gf :call <SID>gf()<CR>

augroup gf
  autocmd!
  autocmd FileType msg,pager nnoremap <buffer> gf :call <SID>gf()<CR>
augroup END
