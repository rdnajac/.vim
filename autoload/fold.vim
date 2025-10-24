scriptencoding utf-8

function! fold#status()
  verbose set foldenable? foldmethod? foldexpr? foldlevel? foldlevelstart? foldminlines?
endfunction

function! fold#text_lua()
  let l:start = v:foldstart
  let l:lines = v:foldend - l:start + 1
  let l:open = getline(l:start)
  let l:next = getline(l:start + 1)

  if indent(l:start + 1) > indent(l:start)
    return substitute(l:open, '{\s*$', '', '')
  endif
  return l:open
endfunction

" TODO: trim trailing dots after closing bar
function! fold#text() abort
  if &ft ==# 'lua'
    return fold#text_lua()
  endif
  let s:foldchar = '.'
  let l:line1 = getline(v:foldstart)

  function! s:CleanLine(line) abort
    return substitute(a:line, '\s*"\?\s*{{{\d*\s*$', '', '')
  endfunction

  function! s:FoldHeader(line1) abort
    if a:line1 =~# '^\s*{'
      let l:next = getline(v:foldstart + 1)
      let l:indent = matchstr(a:line1, '^\s*')
      return l:indent . substitute(l:next, '^\s*', '{ ', '')
    endif
    return s:CleanLine(a:line1)
  endfunction

  let l:line = s:FoldHeader(l:line1)
  let l:lines_count = v:foldend - v:foldstart + 1
  let l:post = '|' . printf('%10s', l:lines_count . ' lines') . ' |'
  let l:pre = l:line . ' '
  let l:fill = repeat(s:foldchar, max([0, 78 - strdisplaywidth(l:pre . l:post)]))

  return l:pre . l:fill . l:post
endfunction

function! fold#open_or_h() abort
  let col = virtcol('.')
  let indent = indent('.')
  if col <= indent + 1 && &l:foldopen =~# 'hor'
    return 'zc'
  else
    return 'h'
  endif
endfunction

function! fold#pause() abort
  if &foldenable
    let b:fold_was_enabled = 1
    set nofoldenable
  endif
endfunction

function! fold#unpause() abort
  if exists('b:fold_was_enabled') && !&foldenable
    unlet b:fold_was_enabled
    set foldenable
    normal! zv
  endif
endfunction

finish " TODO: needs testing
" https://www.reddit.com/r/neovim/comments/1534jt3/showcase_your_folds/
function! fold#setup_search_pause() abort
  nnoremap <silent> / zn/
  nnoremap <silent> ? zn?

  for key in ['n', 'N', '*', '#']
    execute $'nnoremap <silent> {key} <Cmd>call fold#pause()<CR>{key}'
  endfor

  augroup fold_search_pause
    autocmd!
    autocmd CmdlineEnter [/?] call fold#pause()
    autocmd CmdlineLeave [/?] call fold#unpause()
    autocmd CursorMoved * if exists('b:fold_was_enabled') | call fold#unpause() | endif
    autocmd InsertEnter * if exists('b:fold_was_enabled') | call fold#unpause() | endif
  augroup END
endfunction
