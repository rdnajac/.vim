scriptencoding=utf-8

" TODO: rewrite in lua...
function! vimline#winbar#right() abort
  let l:ret = '%='
  let l:ret .= vimline#indicator#diagnostics()
  return ret
endfunction

function! s:path() abort

endfunction

" TODO: special cases for help/man/quickfix windows
function! vimline#winbar#() abort
  " nofile, no winbar
  if &buftype ==# 'nofile'
    return ''
    " elseif &buftype ==# 'help'
    " return '%h'
  elseif &buftype ==# 'quickfix'
    return '%q'
  elseif &buftype ==# 'terminal'
    return ' ' . fnamemodify($PWD, ':~') . '%=ch:' . &channel . ' '
  endif

  let l:is_active_buffer = win_getid() == str2nr(g:actual_curwin)

  let l:ret = ''
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

  " TODO add vimline#detail# section
  if l:is_active_buffer
    if !&modified && !&readonly
      let l:ret .= '%#Chromatophore_c#'
    else
      let l:ret .= '%#Chromatophore_b#'
      let l:ret .= ' '
      let l:ret .= vimline#flag#('readonly')
      let l:ret .= vimline#flag#('modified')
      let l:ret .= '%#Chromatophore_bc#'
      let l:ret .= '%#Chromatophore_c#'
    endif
    let l:ret .= lua#require('vimline.docsymbols', 'get')
  else " inactive winbar
    let l:ret .= vimline#flag#('readonly')
    let l:ret .= vimline#flag#('modified')
  endif

  let l:ret .= vimline#winbar#right()
  return l:ret
endfunction
