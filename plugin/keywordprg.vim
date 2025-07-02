" =============================================================================
" MyKeywordprg.vim - Contextual :Man lookup for keywords under cursor
" Maintainer: me
" License:    MIT
" Version:    1.2
"=============================================================================

if exists('g:loaded_mykeywordprg')
  finish
endif
let g:loaded_mykeywordprg = 1

command! -nargs=* ManLookup call s:ManLookup(<f-args>)

function! s:ManLookup(...) abort
  " echomsg 'ManLookup called with args: ' . string(a:000)
  let l:page = get(b:, 'manpage', '')
  if empty(l:page)
    echohl ErrorMsg
    echo "No b:manpage set. Use 'let b:manpage = ...'."
    echohl None
    return
  endif
  let l:key = a:0 ? a:1 : expand('<cWORD>')
  echomsg 'Looking up "' . l:key . '" in man page: ' . l:page
  execute 'Man ' . l:page
  call search('\<' . l:key . '\>')
endfunction

function! s:KeywordSetup(page) abort
  let b:manpage = a:page
  setlocal keywordprg=:ManLookup
  setlocal iskeyword+=-
endfunction

augroup ManLookupSetup
  autocmd!
  autocmd FileType kitty         call s:KeywordSetup('kitty')
  autocmd FileType tmux          call s:KeywordSetup('tmux')
  autocmd FileType sshconfig     call s:KeywordSetup('ssh')
  autocmd BufRead,BufNewFile *alacritty.*ml call s:KeywordSetup('5 alacritty')
augroup END
