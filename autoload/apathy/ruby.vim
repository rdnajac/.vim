" Remove "." and "" from the otherwise accurate 'path' from ftplugin/ruby.vim
function! apathy#ruby#setup() abort
  if &l:path =~# ',\.,,$'
    let &l:path = substitute(&l:path, ',\.,,$', '', 'g')
  endif
endfunction
