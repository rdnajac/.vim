function! s:ShellScratch() abort
  let cmd = input('$ ')
  if empty(cmd)
    return
  endif
  exec 'noswapfile vnew'
  setlocal buftype=nofile bufhidden=wipe
  let output = split(system(cmd), "\n")
  call setline(1, output)
endfunction


nnoremap <leader>! :call <SID>ShellScratch()<CR>
