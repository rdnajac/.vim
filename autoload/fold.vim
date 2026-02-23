scriptencoding utf-8

function! s:numlines() abort
  return v:foldend - v:foldstart + 1
endfunction

function! s:markers() abort
  let fdm = &l:foldmarker
  return split(fdm, ',')
endfunction

function! s:foldtext(line) abort
  return substitute(a:line, '\s*' . s:markers()[0] . '.*$', '', '')
endfunction

" TODO: trim trailing dots after closing bar and indent folds
function! fold#text() abort
  let s:foldchar = '.' " TODO: use the fillchar?
  let line = s:foldtext(getline(v:foldstart))
  let info = printf('|%4s lines|', s:numlines())
  let fill = repeat(s:foldchar, max([0, 64 - strdisplaywidth(line..' '..info)]))
  return printf('%s %s%s', line, fill, info)
endfunction


function! fold#test() abort
  let line = '" Section: settings {{{1'
  echom s:foldtext(line)
endfunction

finish " TODO: needs testing
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
