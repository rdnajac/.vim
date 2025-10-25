" keywordprg.vim - Configure keywordprg for various filetypes
" This plugin sets up the 'keywordprg' option to enable looking up
" documentation with the K key for different file types.
"
" Supported filetypes:
"   - lua: Uses Vim's :help command
"   - sh: Uses :Man command directly
"   - kitty, tmux, ssh, ghostty, alacritty: Terminal/SSH configs
"   - dockerfile: Docker configuration files
"   - gitconfig: Git configuration files
"   - make: Makefiles
"   - nginx: Nginx configuration files
"   - apache: Apache configuration files
"   - crontab: Crontab files

if exists('g:loaded_mykeywordprg')
  finish
endif
let g:loaded_mykeywordprg = 1

command! -nargs=* ManLookup call s:ManLookup(<f-args>)

function! s:ManLookup(...) abort
  let l:page = get(b:, 'manpage', '')
  if empty(l:page)
    echohl ErrorMsg
    echo "No b:manpage set. Use 'let b:manpage = ...'."
    echohl None
    return
  endif
  " TODO use cword to better match default behavior
  let l:key = a:0 ? a:1 : expand('<cWORD>')
  execute 'Man ' . l:page
  " call search('\<' . l:key . '\>')
  call search( l:key )
endfunction

function! s:KeywordSetup(page) abort
  let b:manpage = a:page
  setlocal keywordprg=:ManLookup
  setlocal iskeyword+=-
endfunction

augroup ManLookupSetup
  autocmd!
  autocmd FileType lua        setlocal keywordprg=:help iskeyword+=-
  autocmd FileType sh         setlocal keywordprg=:Man  iskeyword-=_
  autocmd FileType kitty      call s:KeywordSetup('kitty')
  autocmd FileType tmux       call s:KeywordSetup('tmux')
  autocmd FileType sshconfig  call s:KeywordSetup('ssh')
  autocmd FileType ghostty    call s:KeywordSetup('ghostty')
  autocmd FileType dockerfile call s:KeywordSetup('5 Dockerfile')
  autocmd FileType gitconfig  call s:KeywordSetup('git-config')
  autocmd FileType make       call s:KeywordSetup('make')
  autocmd FileType nginx      call s:KeywordSetup('nginx')
  autocmd FileType apache     call s:KeywordSetup('apache2')
  autocmd FileType crontab    call s:KeywordSetup('5 crontab')
  autocmd BufRead,BufNewFile *alacritty.*ml call s:KeywordSetup('5 alacritty')
augroup END
