function! s:vsplit(path) abort
  let layout = winlayout()
  let cmd = ''
  if empty(bufname())
    let cmd = 'edit'
  elseif layout[0] ==# 'row' && len(layout[1]) > 1
    let rightwin = win_id2win(layout[1][1][1])
    let cmd = rightwin > 0 ? rightwin . 'wincmd w | edit' : 'vsplit'
  else
    let cmd = 'vsplit'
  endif
  execute cmd . ' ' . a:path
  normal! zvzz
endfunction

function! s:edit_if_readable(file) abort
  if filereadable(a:file)
    call s:vsplit(a:file)
  else
    echoerr 'File not found: ' . a:file
  endif
endfunction

function! edit#vimrc(...) abort
  let cmd = (a:0 && !empty(a:1)) ? a:1 : ''
  call s:vsplit((!empty(cmd) ? cmd . ' ' : '') . $MYVIMRC)
endfunction

let s:vimdir = fnamemodify($MYVIMRC, ':p:h')
function! edit#filetype(dir, ext) abort
  let file = &filetype !=# '' ? s:vimdir . '/' . a:dir . &filetype . a:ext : s:vimdir . '/' . a:dir
  call s:vsplit(file)
endfunction

function! edit#module(name) abort
  call s:vsplit(stdpath('config'). '/lua/' . a:name . '.lua')
endfunction

function! edit#ch() abort
  let file = expand('%:p')
  let base = fnamemodify(file, ':t')
  let dir = fnamemodify(file, ':h')
  for swap in [['autoload', 'plugin'], ['plugin', 'autoload']]
    if fnamemodify(dir, ':t') ==# swap[0]
      let alt = fnamemodify(dir, ':h') . '/' . swap[1] . '/' . base
      call s:edit_if_readable(alt)
    endif
  endfor
endfunction
