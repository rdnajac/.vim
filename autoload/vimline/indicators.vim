function! vimline#indicators#bom() abort
  return &fileencoding . (&bomb ? ' [BOM]' : '')
endfunction
