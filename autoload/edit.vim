" TODO: add bool param to set how we open the file
" ie edit/split/vsplit like in picker confirms

function! edit#(...) abort
  call call('s:edit', a:000)
endfunction

function! s:edit(file, ...) abort
  let file = fnamemodify(a:file, ':p')
  let extra = a:0 >= 1 ? a:1 : ''

  " Check if the file exists, if not prompt to create it
  if !filereadable(file)
    let maybe_dir = fnamemodify(a:file, ':r')

    " try file as directory
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

  " If the file is not open, open it in a window
  " If there is only one window, determine the layout based on window size
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

  " If we're focused on a floating window, close it
  if has ('nvim') && luaeval('Snacks.util.is_float() == true')
    quit
  endif

  execute cmd
  normal! zvzz
endfunction

function! edit#vimrc(...) abort
  let vimrc = g:VIMDIR . '/vimrc'
  call call('s:edit', extend([vimrc], a:000))
endfunction

function! edit#luamod(name) abort
  if !has('nvim')
    vim#notify#error('This function is only available in Neovim.')
    return
  endif
  let file = printf('%s/lua/%s.lua', g:stdpath['config'], a:name)
  if !filereadable(file)
    let file = printf('%s/lua/%s/init.lua', g:stdpath['config'], a:name)|
  endif
  call s:edit(file)
endfunction

function! edit#filetype(...) abort
  if &filetype ==# ''
    call vim#notify#error('`filetype` is empty!')
    return
  endif

  let dir = join([g:VIMDIR, 'after', 'ftplugin'], '/')
  let ext =  a:0 == 0 ? '.vim' : a:1

  call s:edit(join([g:VIMDIR, dir, &filetype .. ext], '/'))
endfunction

function! edit#snippet() abort
  call edit#filetype('snippets', '.json')
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
