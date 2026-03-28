" delete/yank comment object
nmap dc dgc
nmap yc ygc

" TODO: make this an opfunc
nmap gy "xyygcc"xp<Up>
nmap gY "xyygcc"xP

" toggle comment line
nmap vv Vgc

" don't capture whitespace in `gc`
nmap gcap gcip

function! s:toggle_comment() abort
  " vint: -ProhibitCommandRelyOnUser
  normal gcc
  " vint: +ProhibitCommandRelyOnUser
endfunction

function! s:title() abort
  let fname = fnamemodify(expand('%'), ':p')
  let fname = substitute(fname, git#root(), '', '')
  let fname = substitute(fname, '^\/*', '', '')
  " let fname = substitute(fname, '^[\/\s]\+', '', '')
  " return fname
  execute append(0, fname)
  call s:toggle_comment()
endfunction

nnoremap cy <Cmd>call <SID>title()<CR>

let s:comments = {
      \ 'o': '',
      \ 'b': 'BUG: ',
      \ 'f': 'FIXME: ',
      \ 'h': 'HACK: ',
      \ 'w': 'WARN: ',
      \ 'n': 'NOTE: ',
      \ 't': 'TODO: ',
      \ 'x': 'XXX: ',
      \ 'i': 'stylua: ignore',
      \ }


function comment#syntax_match(...) abort
  let pos = a:0 ? a:1 : getpos('.')
  let synid = synID(pos[1], pos[2], 1)
  let name  = synIDattr(synid, 'name')
  Info name
  return !empty(name) && name =~# 'Comment'
endfunction

function! s:comment(above, tag) abort
  execute 'normal! ' .. (a:above ? 'O' : 'o') .. a:tag
  if !comment#syntax_match(getpos('.'))
    call s:toggle_comment()
  endif
  if a:tag =~ ':\s'
    startinsert!
  endif
endfunction

function! comment#above(tag) abort
  call s:comment(1, a:tag)
endfunction

function! comment#below(tag) abort
  call s:comment(0, a:tag)
endfunction

" map `co` and `cO` to insert comments with specific tags
for [key, val] in items(s:comments)
  execute printf('nnoremap co%s <Cmd>call comment#below("%s")<CR>', key, val)
  execute printf('nnoremap cO%s <Cmd>call comment#above("%s")<CR>', key, val)
  execute printf('nnoremap co%s <Cmd>call comment#above("%s")<CR>', toupper(key), val)
endfor

if !has('nvim')
  " see `:h package-comment`
  " BUG: still does not work with the version of vim on homebrew
  " issue: https://github.com/vim/vim/issues/14171
  " commit: https://github.com/vim/vim/commit/fa6300872732f80b770a768e785ae2b189d3e684
  " patch 9.1.0165: Vim9: Importing an autoload imported script fails
  " still broken...
  " HACK: manually sourcing this resolves E1041 `Toggle`
  source $VIMRUNTIME/pack/dist/opt/comment/autoload/comment.vim
endif
"comment.vim" 85L, 2330B [w]
