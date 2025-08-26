function! s:resolve(path) abort
  return substitute(matchstr(fnamemodify(a:path, ':r'), 'ftplugin/\zs.*'), '/.*', '', '')
endfunction

function! s:reload_ft_for_buffer(buf, filetype) abort
  if bufexists(a:buf) && buflisted(a:buf) && getbufvar(a:buf, '&filetype') ==# a:filetype
    execute a:buf . 'bufdo doautocmd FileType ' . a:filetype
  endif
endfunction

function! reload#loop(filetype) abort
  for b in range(1, bufnr('$'))
    call s:reload_ft_for_buffer(b, a:filetype)
  endfor
endfunction

function! reload#ftplugin(path) abort
  let l:filetype = s:resolve(a:path)
  call vim#notify#info('Reloading ftplugin for ' . l:filetype)
  call execute#withSavedState('call reload#loop("' . l:filetype . '")')
endfunction

function! reload#vimscript(file) abort
  silent! mkview
  execute 'source' fnameescape(a:file)
  silent! loadview
  call vim#notify#info('Sourced ' . a:file . '!')
endfunction

function! reload#() abort
  if exists(':Runtime')
    let files = globpath(&rtp, '**/*.vim', 0, 1)
    call execute#inPlace('Runtime! ' . join(files))
    call vim#notify#info('Reloaded all scripts!')
  else
    call vim#notify#warn('Runtime command not available. Install vim-scriptease.')
  endif
endfunction
