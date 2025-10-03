function s:fticon() abort
  return ' ' . v:lua.nv.icons.fticon()
endfunction

function! vimline#winbar#() abort
  let l:is_active_buffer = win_getid() == str2nr(g:actual_curwin)

  let l:ret = ''
  let l:ret = '%#Chromatophore_a#'
  let l:ret .=  s:fticon()
  if l:is_active_buffer
    let l:ret .= '%t'
    let l:ret .= '%#Chromatophore_b#'
    let l:ret .= ' '
    let l:ret .= vimline#flag#('readonly')
    let l:ret .= vimline#flag#('modified')
    let l:ret .= v:lua.nv.treesitter.status()
    let l:ret .= v:lua.nv.lsp.status()
    let l:ret .= v:lua.nv.sidekick.status()
    let l:ret .= v:lua.nv.diagnostic.status()
    let l:ret .= '%#Chromatophore_bc#'
    let l:ret .= '%#Chromatophore_c#'
    let l:ret .= v:lua.nv.lsp.docsymbols()
  else " inactive winbar
    let l:ret .= '%{expand("%:~:.")}'
    let l:ret .= ' '
    let l:ret .= vimline#flag#('readonly')
    let l:ret .= vimline#flag#('modified')
  endif
  return l:ret
endfunction
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
    let l:ret .=  s:fticon()
    let l:ret .= fnamemodify(v:lua.require'oil'.get_current_dir(), ':~')
  elseif &filetype ==# 'nvim-pack'
    let l:ret .='  ' " TODO: make this the fticon for nvim-pack
    let l:ret .='TODO: print relevant status info'
    " let l:ret .= v:lua.nv.plug.status()
    " let l:ret .=luaeval("#vim.pack.get()"))
  endif
  return l:ret
endfunction



