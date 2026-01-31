" https://gist.github.com/romainl/b00ccf58d40f522186528012fd8cd13d
function! vim#opfunc#substitute(type, ...)
  let cur = getpos("''")
  call cursor(cur[1], cur[2])
  let cword = expand('<cword>')
  execute "'[,']s/" . cword . '/' . input(cword . '/')
  call cursor(cur[1], cur[2])
endfunction
" go substitue
nmap <silent> gs m':set opfunc=Substitute<CR>g@
" Usage:
"   <key>ipfoo<CR>         Substitute every occurrence of the word under
"                          the cursor with 'bar' in the current paragraph
"   <key>Gbar<CR>          Diff, fprom here to the end of the buffer
"   <key>?bar<CR>bar<CR>   Diff, from previous occurrence of 'bar'
"                          to current line

"   <key>ipbar<CR>         Substitute every occurrence of the word under
"                          the cursor with 'bar' in the current paragraph
"   <key>Gbar<CR>          Diff, fprom here to the end of the buffer
"   <key>?bar<CR>bar<CR>   Diff, from previous occurrence of 'bar'
"                          to current line


function! vim#opfunc#format(type, ...)
  if !empty(&formatprg)
    normal! '[v']gq
    call s:err_undo()
  else
    normal! '[v']=
    call format#clean_whitespace()
  endif
  call winrestview(w:gqview)
  unlet w:gqview
endfunction

" nnoremap <silent> gq :<C-U>let w:gqview=winsaveview()<CR>:set opfunc=keymap#opfunc#format<CR>g@
