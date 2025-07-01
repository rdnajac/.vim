" =============================================================================
" MyKeywordprg.vim - Contextual :Man lookup for keywords under cursor
" Maintainer: me
" License:    MIT
" Version:    1.1
"=============================================================================

if exists('g:loaded_mykeywordprg')
  finish
endif
let g:loaded_mykeywordprg = 1

command! -nargs=* ManLookup call s:ManLookup(<f-args>)

function! s:ManLookup(...) abort
  echomsg 'ManLookup called with args: ' . string(a:000)
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

augroup ManLookupSetup
  autocmd!
  autocmd FileType kitty        let b:manpage = 'kitty'      | setlocal keywordprg=:ManLookup
  autocmd FileType tmux         let b:manpage = 'tmux'       | setlocal keywordprg=:ManLookup
  autocmd FileType sshconfig    let b:manpage = 'ssh'        | setlocal keywordprg=:ManLookup
  autocmd BufRead,BufNewFile *alacritty.*ml let b:manpage = '5 alacritty' | setl keykp=:ManLookup
augroup END
