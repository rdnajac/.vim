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
