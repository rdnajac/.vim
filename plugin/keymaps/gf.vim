" ~/.local/share/nvim/startuptime.log
function! s:gf(word)
  if a:word ==# ''
    return
  endif
  " call vim#close#float()
  if a:word =~# ':\d\+$'
    " Looks like file:line
    echo 'Line number detected, using built-in gF'
    " doesn't work if the cursor is on the `:` or line number
    " TODO: move the cursor?
    " execute 'normal! gF'
    wincmd F
  else
    wincmd f
    " CTRL-W_CTRL-F
    " execute 'edit' fnameescape(a:word)
  endif
endfunction
" wincmd f is an alias for CTRL-W CTRL-F and 
" doesnt have a versiohn that does to the line number
" TODO: add this
" NOTE:
" CTRL-W gF works but doesnt open a new window
"

nnoremap gf :call <SID>gf(expand('<cWORD>'))<CR>

" augroup gf
"   autocmd!
"   autocmd FileType msg,pager nnoremap <buffer> gf :call <SID>gf()<CR>
" augroup END
