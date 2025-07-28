function! s:close_other_buffer() abort
  if has('nvim')
    if luaeval("require('snacks.util').is_float()")
      quit
    elseif &ft ==# 'snacks_dashboard'
      doautocmd User SnacksDashboardClosed
      bdelete
    endif
  endif
endfunction

function! s:edit(file, ...) abort
  let l:extra = a:0 >= 1 ? a:1 : ''

  " Check if the file exists, if not prompt to create it
  if !filereadable(a:file)
    let l:resp = input('File not found: ' .  fnamemodify(a:file, ':~') . '. Create new file? [y/N]: ')
    if l:resp !~? '^y'
      return
    endif
  endif

  " Jump to buffer if already open in current tab
  for w in range(1, winnr('$'))
    if bufexists(winbufnr(w)) && fnamemodify(bufname(winbufnr(w)), ':p') ==# fnamemodify(a:file, ':p')
      execute w . 'wincmd w'
      if l:extra =~# '\v(^|\s)\+\S'
	execute matchstr(l:extra, '\v\+\S+')
	normal! zvzz
      endif
      return
    endif
  endfor

  " If the file is not open, open it in a window
  " If there is only one window, determine the layout based on window size
  let l:layout = ''
  if winnr('$') > 1
    execute (winnr() % winnr('$') + 1) . 'wincmd w'
  else
    if bufname('%') !=# ''
      let l:layout = &columns > 80 ? 'vsplit' : &columns > 20 ? 'split' : ''
    endif
  endif

  " prepend the command with the layout if it is not empty
  let l:cmd = (!empty(l:layout) ? l:layout . ' | ' : '') . 'drop '
  " insert the extra command if it is not empty
  let l:cmd .= (!empty(l:extra) ? l:extra . ' ' : '') . fnameescape(a:file)

  " If we're focused on a floating window, close it
  call s:close_other_buffer()
  " execute the command to open the file
  " echom 'Executing: ' . l:cmd
  execute l:cmd
  " open and close folds and center the view
  normal! zvzz
endfunction

function! edit#vimrc(...) abort
  call call('s:edit', extend([$MYVIMRC], a:000))
endfunction

function! edit#module(name) abort
  if !has('nvim')
    echoerr 'This function is only available in Neovim.'
    return
  endif
  let l:file = stdpath('config') . '/lua/' . a:name . '.lua'
  call s:edit(l:file)
endfunction

" Optional parameters:
" - a:1 = dir (default: vim#home . '/after/ftplugin')
" - a:2 = ext (default: '.vim')
function! edit#filetype(...) abort
  if &filetype ==# ''
    echoerr 'Filetype is not set.'
    return
  endif
  let l:dir = vim#home() . (a:0 >= 1 ? '/' . a:1 : '/after/ftplugin')
  let l:ext = a:0 >= 2 ? a:2 : '.vim'
  let l:file = l:dir . '/' . &filetype . l:ext
  call s:edit(l:file)
endfunction

" TODO: move this to vim ftplugin
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

  call s:edit(alt_file)
endfunction

function! s:find_nearest_readme() abort
  let l:dir = fnamemodify(expand('%:p'), ':p:h')
  let l:home = fnamemodify('~', ':p')
  while l:dir !=# '/' && l:dir !=# l:home
    let l:readme = l:dir . '/README.md'
    if filereadable(l:readme)
      return l:readme
    endif
    let l:dir = fnamemodify(l:dir, ':h')
  endwhile
  return ''
endfunction

function! edit#readme() abort
  let l:readme = s:find_nearest_readme()
  if empty(l:readme)
    let l:readme = fnamemodify(expand('%:p'), ':h') . '/README.md'
  endif
  call s:edit(l:readme)
endfunction
