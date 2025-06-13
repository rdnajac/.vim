if exists('g:loaded_ooze') || &cp || v:version < 700
  finish
endif
let g:loaded_ooze = 1

" if !(exists(expr)... save a directory as a global variable to move back
" to the pinned directory

command! -range=% OozeVisual call ooze#visual()

if !exists('g:oil_winid')
  let g:oil_winid = -1
endif

function! s:open_oil() abort
  if win_id2win(g:oil_winid) > 0 && bufexists(winbufnr(g:oil_winid)) && getbufvar(winbufnr(g:oil_winid), '&filetype') ==# 'oil'
    call nvim_set_current_win(g:oil_winid)
    wincmd c
    let g:oil_winid = -1
  else
    leftabove 30vsplit
    Oil
    let g:oil_winid = win_getid()
    augroup OilGuard
      autocmd!
      execute 'autocmd BufEnter * if win_getid() ==# ' . g:oil_winid . ' && &filetype !=# "oil" | wincmd c | let g:oil_winid = -1 | endif'
    augroup END
  endif
endfunction

nnoremap <leader>e :call <SID>open_oil()<CR>
