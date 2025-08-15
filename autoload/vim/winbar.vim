function! vim#winbar#right() abort
  let l:ret = '%='
  let l:ret .= v:lua.require'vimline'.diagnostics()
  return ret
endfunction

function! vim#winbar#() abort
  if &ft ==# 'snacks_dashboard'
    return '%#Chromatophore#snacks_dashboard'
  endif
  let l:ret = ''
  let l:ret .= ' '
  let l:ret .= v:lua.require'vimline.file'.ft_icon() . ' '
  let l:ret .= fnamemodify(bufname('%'), ':t')
  " check if the current window is the one we are in
  if win_getid() == str2nr(g:actual_curwin)
    " TODO: add wrapper so that we have a fallback if not using nvim we can just return ''
    let l:ret .= '%#Chromatophore_c#'
    let l:ret .= v:lua.require'vimline.docsymbols'.get()
  endif
  return l:ret
endfunctio
