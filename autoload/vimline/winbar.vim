scriptencoding utf-8

function vimline#winbar#terminal() abort
  let l:ret = ''
  let l:ret .= '%#Chromatophore_a# '
  let l:ret .= fnamemodify(getcwd(), ':~') . ' '
  let l:ret .= '%#Chromatophore_b# '

  if exists('g:ooze_channel') && g:ooze_channel == &channel
    let l:ret .= ' '
  else
    let l:ret .= ' '
  endif
  let l:ret.= ' [' . &channel . '] '
  let l:ret .= '%#Chromatophore_bc# '
  return l:ret
endfunction

" HACK: what other bufftypes use acwrite?
function! vimline#winbar#acwrite() abort
  let l:ret = ''
  let l:ret = '%#Chromatophore_a#'
  if &filetype ==# 'oil'
    let l:ret .= ' ' . v:lua.nv.icons()
    let l:ret .= fnamemodify(lua#require('oil', 'get_current_dir'), ':~')
  elseif &filetype ==# 'nvim-pack'
    let l:ret .= v:lua.nv.plug.status()
  endif
  return l:ret
endfunction


function! vimline#winbar#() abort
  let l:is_active_buffer = win_getid() == str2nr(g:actual_curwin)

  let l:ret = ''
  let l:ret = '%#Chromatophore_a#'
    let l:ret .= ' ' . v:lua.nv.icons() . ' '

  " if &filetype ==# 'oil'
  "   let l:ret .= fnamemodify(lua#require('oil', 'get_current_dir'), ':~')
  " else
    if l:is_active_buffer
      let l:ret .= '%t'
    else
      let l:ret .= '%{expand("%:~:.")}'
    endif
  " endif

  let l:ret .= ' '
  if l:is_active_buffer
    let l:ret .= '%#Chromatophore_b#'
    let l:ret .= ' '
    let l:ret .= vimline#flag#('readonly')
    let l:ret .= vimline#flag#('modified')
    let l:ret .= v:lua.nv.status()
    let l:ret .= '%#Chromatophore_bc#'
    let l:ret .= '%#Chromatophore_c#'
    let l:ret .= v:lua.nv.lsp.docsymbols()
  else " inactive winbar
    let l:ret .= vimline#flag#('readonly')
    let l:ret .= vimline#flag#('modified')
  endif
  return l:ret
endfunction
