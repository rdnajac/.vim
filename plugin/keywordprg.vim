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

function! s:setmanpage(page) abort
  let b:manpage = a:page
  setlocal keywordprg=:ManLookup
  setlocal iskeyword+=-
endfunction

let s:filetypes = ['kitty', 'tmux', 'ghostty', 'sshconfig', 'gitconfig', 'gitconfig.chezmoitmpl']
let s:manmap = {
      \ 'sshconfig': 'ssh',
      \ 'gitconfig': 'git-config(1)',
      \ 'gitconfig.chezmoitmpl': 'git-config(1)',
      \ }

augroup vimrc_keywordprg
  autocmd!
  autocmd FileType vim nnoremap <silent><buffer> <leader>K <Plug>ScripteaseHelp
  autocmd FileType tex nnoremap <silent><buffer> <leader>K <Plug>(vimtex-doc-package)
  autocmd FileType lua setlocal keywordprg=:help iskeyword+=-
  autocmd FileType sh  setlocal keywordprg=:Man  iskeyword-=_
  for ft in s:filetypes
    let manpage = has_key(s:manmap, ft) ? s:manmap[ft] : ft
    execute printf('autocmd FileType %s call s:setmanpage(%s)', ft, string(ft))
  endfor
  autocmd BufRead,BufNewFile *alacritty.*ml call s:setmanpage('5 alacritty')
augroup END
