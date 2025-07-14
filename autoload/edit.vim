function! s:edit(...) abort
  " Accepts ([+cmd], file)
  let l:cmd  = a:0 > 1 ? a:1 : ''
  let l:file = a:0 > 1 ? a:2 : a:0 == 1 ? a:1 : ''
  if empty(l:file)
    return
  endif
  let l:buf_p = expand(fnamemodify(l:file, ':p'))

  " If open in any window in the current tab, jump there.
  for w in range(1, winnr('$'))
    if expand('#' . winbufnr(w) . ':p') ==# l:buf_p
      execute w . 'wincmd w'
      return
    endif
  endfor

  " If more than one window, go to the alternate window (next one), open normally there.
  if winnr('$') > 1
    let l:cur = winnr()
    let l:alt = l:cur % winnr('$') + 1
    execute l:alt . 'wincmd w'
    execute 'drop ' . (l:cmd != '' ? l:cmd . ' ' : '') . fnameescape(l:file)
    normal! zvzz
    return
  endif

  " Otherwise, open in new vertical split
  execute 'vsplit | drop ' . (l:cmd != '' ? l:cmd . ' ' : '') . fnameescape(l:file)
  normal! zvzz
endfunction

function! edit#vimrc(...) abort
  let l:section = a:0 && !empty(a:1) ? a:1 : ''
  if fnamemodify(bufname('%'), ':p') ==# fnamemodify($MYVIMRC, ':p')
    if !empty(l:section)
      call search(l:section)
    endif
  else
    call s:edit(!empty(l:section) ? '+/' . l:section : '', $MYVIMRC)
  endif
endfunction

let s:vimdir = fnamemodify($MYVIMRC, ':p:h')

function! edit#filetype(dir, ext) abort
  let l:file = (&filetype !=# '') ? s:vimdir . '/' . a:dir . &filetype . a:ext : s:vimdir . '/' . a:dir
  call s:edit(l:file)
endfunction

function! s:edit_if_readable(file, ...) abort
  if filereadable(a:file)
    if a:0 > 0
      call call('s:edit', [a:1, a:file])
    else
      call s:edit(a:file)
    endif
  else
    echoerr 'File not found: ' . a:file
  endif
endfunction

function! edit#module(name) abort
  let l:file = stdpath('config') . '/lua/' . a:name . '.lua'
  call s:edit_if_readable(l:file)
endfunction

function! edit#ch() abort
  let l:file = expand('%:p')
  let l:base = fnamemodify(l:file, ':t')
  let l:dir = fnamemodify(l:file, ':h')
  let l:found = 0
  for l:swap in [['autoload', 'plugin'], ['plugin', 'autoload']]
    if fnamemodify(l:dir, ':t') ==# l:swap[0]
      let l:alt = fnamemodify(l:dir, ':h') . '/' . l:swap[1] . '/' . l:base
      if filereadable(l:alt)
	call s:edit_if_readable(l:alt)
	let l:found = 1
	break
      endif
    endif
  endfor
  if !l:found
    echoerr 'File not found: companion for ' . l:file
  endif
endfunction
