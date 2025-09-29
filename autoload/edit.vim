function! s:close_other_buffer() abort
  if has('nvim')
    if exists('v:lua.package') && luaeval("package.loaded['snacks'] ~= nil")
      if luaeval("require('snacks.util').is_float()")
	quit
      else
	bdelete
      endif
    endif
  endif
endfunction

function! edit#(...) abort
  call call('s:edit', a:000)
endfunction

function! s:edit(file, ...) abort
  let l:file = fnamemodify(a:file, ':p')
  let l:extra = a:0 >= 1 ? a:1 : ''

  " Check if the file exists, if not prompt to create it
  " TODO: don't prompt if trying to access a dir
  if !filereadable(l:file)
    let l:maybe_dir = fnamemodify(a:file, ':r')

    " try file as directory
    if isdirectory(l:maybe_dir)
      let l:file = l:maybe_dir . '/'
    else

      " prompt to create the file, exit if the user declines
      let l:resp = input('File not found: ' .  fnamemodify(a:file, ':~') . '. Create new file? [y/N]: ')
      if l:resp !~? '^y'
	return
      endif
    endif
  endif

  " Jump to buffer if already open in current tab
  for w in range(1, winnr('$'))
    if bufexists(winbufnr(w)) && fnamemodify(bufname(winbufnr(w)), ':p') ==# l:file
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
  let l:cmd .= (!empty(l:extra) ? l:extra . ' ' : '') . l:file

  " If we're focused on a floating window, close it
  call s:close_other_buffer()

  execute l:cmd
  normal! zvzz
endfunction

let s:myvimrc = vimrc#home() . '/vimrc'
function! edit#vimrc(...) abort
  call call('s:edit', extend([s:myvimrc], a:000))
endfunction

function! edit#luamod(name) abort
  if !has('nvim')
    vim#notify#error('This function is only available in Neovim.')
    return
  endif
  " TODO: handle /init.lua
  let l:file = stdpath('config') . '/lua/' . a:name . '.lua'

  call s:edit(l:file)
endfunction

" Optional parameters:
" - a:1 = dir (default: vim#home . '/after/ftplugin')
" - a:2 = ext (default: '.vim')
function! edit#filetype(...) abort
  if &filetype ==# ''
    call vim#notify#error('filetype is empty')
  endif
  let l:dir = vimrc#home() . (a:0 >= 1 ? '/' . a:1 : '/after/ftplugin')
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

  " call s:edit(alt_file)
  execute 'edit ' . alt_file
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
