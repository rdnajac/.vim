" autoload/comment.vim
function! comment#toggle() abort
  " vint: -ProhibitCommandRelyOnUser
  normal gcc
  " vint: +ProhibitCommandRelyOnUser
endfunction

function! s:title() abort
  let fname = fnamemodify(expand('%'), ':p')
  let fname = substitute(fname, git#root(), '', '')
  let fname = substitute(fname, '^\/*', '', '')
  let fname = substitute(fname, '^\s\+', '', '')
  return fname
endfunction

function! comment#title() abort
  execute append(0, s:title())
  call comment#toggle()
endfunction

function comment#syntax_match(...) abort
  let pos = a:0 ? a:1 : getpos('.')
  let synid = synID(pos[1], pos[2], 1)
  let name  = synIDattr(synid, 'name')
  return !empty(name) && name =~# 'Comment'
endfunction

function! s:insert_comment(tag, above) abort
  execute 'normal ' .. (a:above ? 'O' : 'o') .. a:tag ..'' .. (comment#syntax_match() ? '' : 'gcc')
  call feedkeys('A')
endfunction

function! comment#above(tag) abort
  call s:insert_comment(a:tag, v:true)
endfunction

function! comment#below(tag) abort
  call s:insert_comment(a:tag, v:false)
endfunction
