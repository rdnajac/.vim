function! reload#ftplugin(filetype) abort
  call vim#notify#info('Reloading ftplugin for ' . a:filetype)
  for b in range(1, bufnr('$'))
    if bufexists(b) && buflisted(b)
      let ft = getbufvar(b, '&filetype')
      if ft ==# a:filetype
	" Reload the ftplugin
	call setbufvar(b, '&filetype', ft)
	execute b . 'bufdo doautocmd FileType ' . a:filetype
      endif
    endif
  endfor
endfunction
