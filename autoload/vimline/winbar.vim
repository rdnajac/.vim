scriptencoding=utf-8
function! vimline#winbar#() abort
  let l:bt = &buftype

  if l:bt ==# 'nofile'
    return ''
  elseif l:bt ==# 'quickfix'
    return '%q'
  elseif l:bt ==# 'terminal'
    return ' ' . fnamemodify($PWD, ':~') . '%=ch:' . &channel . ' '
  endif

  let l:is_active_buffer = win_getid() == str2nr(g:actual_curwin)

  let l:ret = ''
  let l:ret = '%#Chromatophore_a#'
  let l:ret .= ' ' . lua#require('vimline', 'ft_icon') . ' '

  if &filetype ==# 'oil'
    let l:ret .= fnamemodify(lua#require('oil', 'get_current_dir'), ':~')
  else
    if l:is_active_buffer
      let l:ret .= '%t'
    else
      let l:ret .= '%{expand("%:~:.")}'
    endif
  endif

  let l:ret .= ' '

  if l:is_active_buffer
    " if !&modified && !&readonly
      " let l:ret .= '%#Chromatophore_c#'
    " else
      let l:ret .= '%#Chromatophore_b#'
      let l:ret .= ' '
      let l:ret .= vimline#flag#('readonly')
      let l:ret .= vimline#flag#('modified')
      " let l:ret .= lua#require('vimline', 'diagnostic')
      let l:ret .= v:lua.require'nvim.diagnostic'.component()
      let l:ret .= '%#Chromatophore_bc#'
      let l:ret .= '%#Chromatophore_c#'
    " endif
    let l:ret .= lua#require('vimline', 'docsymbols')
  else " inactive winbar
    let l:ret .= vimline#flag#('readonly')
    let l:ret .= vimline#flag#('modified')
    " let l:ret .= l:diagnostics
  endif
  return l:ret
endfunction
