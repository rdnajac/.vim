command! -nargs=+ DiffBufs call s:DiffTwoBufs(<f-args>)

function! s:DiffTwoBufs(buf1, buf2) abort
  execute 'buffer' a:buf1
  execute 'vert sbuffer' a:buf2
  diffthis
  wincmd p
  diffthis
endfunction
