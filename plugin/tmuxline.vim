function! Clock() abort
  let l:line .= '%=%#Chromatophore_z#   ' . strftime('%T') . ' %#Normal#'
endfunction

function! TmuxLeft() abort
  return vimline#tmuxline('MyTmuxLine')
endfunction

function! TmuxRight() abort
  return vimline#tmuxline('Clock')
endfunction
