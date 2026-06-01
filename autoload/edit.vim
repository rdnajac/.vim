" TODO: add param to set how we open the file
" ie edit/split/vsplit like in picker confirms
function! s:apply_extra(extra) abort
  if a:extra =~# '\v(^|\s)\+\S'
    execute matchstr(a:extra, '\v\+\S+')
    normal! zvzz
  endif
endfunction

function! s:build_cmd(layout, extra, file) abort
  let cmd = (!empty(a:layout) ? a:layout..' | ' : '')..'drop '
  let cmd .= (!empty(a:extra) ? a:extra..' ' : '')..fnameescape(a:file)
  return cmd
endfunction

function! s:find_bufwin(buf) abort
  let wins = win_findbuf(a:buf)
  if !empty(wins)
    return [wins[0], 0]
  endif
  let winid = bufwinid(a:buf)
  if winid != -1
    return [winid, 0]
  endif
  for w in range(1, winnr('$'))
    if winbufnr(w) == a:buf
      return [win_getid(w), w]
    endif
  endfor
  return [0, 0]
endfunction

function! edit#(file, ...) abort
  let file = a:file
  let extra = a:0 >= 1 ? a:1 : ''

  if !filereadable(file)
    let maybe_dir = fnamemodify(file, ':r')
    if isdirectory(maybe_dir)
      let file = maybe_dir..'/'
    endif
  endif

  " Jump to buffer if already open in current tab
  let buf = bufnr(file)
  if buf > 0
    let [winid, wnr] = s:find_bufwin(buf)
    if winid > 0
      call win_gotoid(winid)
      call s:apply_extra(extra)
      return
    elseif wnr > 0
      execute wnr..'wincmd w'
      call s:apply_extra(extra)
      return
    endif
  endif

  " if the file is not open, open it in a window
  " if there is only one window, determine the layout based on window size
  " TODO: let layout be an optional arguent that we solve for if it doesn exist
  let layout = ''
  if winnr('$') > 1
    let cur = win_getid()
    for info in getwininfo()
      if info.winid !=# cur
        call win_gotoid(info.winid)
        break
      endif
    endfor
  else
    if bufname('%') !=# ''
      let layout = &columns > 80 ? 'vsplit' : &columns > 20 ? 'split' : ''
    endif
  endif

  let cmd = s:build_cmd(layout, extra, file)
  " If we're focused on a floating window, close it first
  " if !empty(nvim_win_get_config(0).relative) | quit | endif
  execute cmd
  call s:apply_extra(extra)
endfunction

function! edit#goto(...) abort
  let cfile = a:0 > 0 && !empty(a:1) ? a:1 : expand('<cfile>')
  let lnum = a:0 > 1 && !empty(a:2) ? a:2 : ''
  if empty(lnum)
    let line = getline('.')
    let lnum = matchstr(line, ':\zs\d\+')
  endif
  let lnum = str2nr(lnum)
  let args = [cfile]
  if lnum > 0
    call add(args, '+'..lnum)
  endif
  call call('edit#', args)
endfunction

function! s:filetype(dir, ext) abort
  call edit#(join([g:vimrc#dir, a:dir, &filetype .. a:ext], '/'))
endfunction

function! edit#ftplugin(...) abort
  call s:filetype('after/ftplugin', a:0 == 0 ? '.vim' : a:1 )
endfunction

function! edit#snippets() abort
  call s:filetype('snippets', '.json')
endfunction

" TODO: can simplify
" edit the corresponding autoload or plugin file
function! edit#ch() abort
  if expand('%:p') !~# '\.vim$' || expand('%:p') !~# 'autoload\|plugin'
    return
  endif
  let tag = expand('%:p:h:t')
  let alt_dir = expand('%:p:h:h')..'/'..(tag ==# 'autoload' ? 'plugin' : 'autoload')
  let alt_file = alt_dir..'/'..expand('%:t')
  " call edit#(alt_file)
  execute 'edit' alt_file
endfunction

function! s:find_nearest_readme() abort
  let dir = expand('%:p:h')
  let home = expand('~')
  while dir !=# '/' && dir !=# home
    let readme = dir..'/README.md'
    if filereadable(readme)
      return readme
    endif
    let dir = fnamemodify(dir, ':h')
  endwhile
  return ''
endfunction

function! edit#readme() abort
  let readme = s:find_nearest_readme()
  let readme = !empty(readme) ? readme : expand('%:p:h')..'/README.md'
  call edit#(readme)
endfunction
