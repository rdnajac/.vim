function! substitute#all(find, replace) abort
  " escape any slash or backslash in the arguments
  let l:find    = escape(a:find,    '/\')
  let l:replace = escape(a:replace, '/\')
  " run the substitute in every buffer, then write if changed
  execute 'bufdo %s/\V' . l:find . '/' . l:replace . '/g | update'
endfunction
