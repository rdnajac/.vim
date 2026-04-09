  " create an ephemeral buffer containing the clipboard contents
  " on write, yank the buffer contents to the clipboard and delete the buffer
function! edit#clipboard() abort
  edit +setl\ bt=acwrite\ bh=wipe\ nobl\ noswf Clipboard
  silent execute 'put +|1d _'
  au BufWriteCmd <buffer> %yank + | set nomodified'
endfunction

" TODO: add param to set how we open the file
" ie edit/split/vsplit like in picker confirms
function! edit#(...) abort
  call call('s:edit', a:000)
endfunction

function! s:edit(file, ...) abort
  let file = fnamemodify(a:file, ':p')
  let extra = a:0 >= 1 ? a:1 : ''

  if !filereadable(file)
    let maybe_dir = fnamemodify(a:file, ':r')
    if isdirectory(maybe_dir)
      let file = maybe_dir . '/'
    endif
  endif

  " Jump to buffer if already open in current tab
  for w in range(1, winnr('$'))
    if bufexists(winbufnr(w)) && fnamemodify(bufname(winbufnr(w)), ':p') ==# file
      execute w . 'wincmd w'
      if extra =~# '\v(^|\s)\+\S'
	execute matchstr(extra, '\v\+\S+')
	normal! zvzz
      endif
      return
    endif
  endfor

  " if the file is not open, open it in a window
  " if there is only one window, determine the layout based on window size
  " TODO: let layout be an optional arguent that we solve for if it doesn exist
  let layout = ''
  if winnr('$') > 1
    execute (winnr() % winnr('$') + 1) . 'wincmd w'
  else
    if bufname('%') !=# ''
      let layout = &columns > 80 ? 'vsplit' : &columns > 20 ? 'split' : ''
    endif
  endif

  " prepend the command with the layout if it is not empty
  let cmd = (!empty(layout) ? layout . ' | ' : '') . 'drop '
  " insert the extra command if it is not empty
  let cmd .= (!empty(extra) ? extra . ' ' : '') . file
  " If we're focused on a floating window, close it first
  " if !empty(nvim_win_get_config(0).relative) | quit | endif
  execute cmd
  normal! zvzz
endfunction

function! s:filetype(dir, ext) abort
  call s:edit(join([g:vimrc#dir, a:dir, &filetype .. a:ext], '/'))
endfunction

function! edit#ftplugin(...) abort
  call s:filetype('after/ftplugin', a:0 == 0 ? '.vim' : a:1 )
endfunction

function! edit#snippets() abort
  call s:filetype('snippets', '.json')
endfunction

" edit the corresponding autoload or plugin file
function! edit#ch() abort
  let file = expand('%:p')
  if file !~# '\.vim$' | return | endif

  let base = fnamemodify(file, ':t')
  let dir = fnamemodify(file, ':h')
  let tag = fnamemodify(dir, ':t')

  if index(['autoload', 'plugin'], tag) < 0 | return | endif

  let alt_dir = fnamemodify(dir, ':h') . '/' . (tag ==# 'autoload' ? 'plugin' : 'autoload')
  let alt_file = alt_dir . '/' . base

  " call s:edit(alt_file)
  execute 'edit ' . alt_file
endfunction

function! s:find_nearest_readme() abort
  let dir = fnamemodify(expand('%:p'), ':p:h')
  let home = fnamemodify('~', ':p')
  while dir !=# '/' && dir !=# home
    let readme = dir . '/README.md'
    if filereadable(readme)
      return readme
    endif
    let dir = fnamemodify(dir, ':h')
  endwhile
  return ''
endfunction

function! edit#readme() abort
  let readme = s:find_nearest_readme()
  if empty(readme)
    let readme = fnamemodify(expand('%:p'), ':h') . '/README.md'
  endif
  call s:edit(readme)
endfunction
