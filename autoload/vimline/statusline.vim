scriptencoding utf-8

let s:default = "%<%f %h%w%m%r "
let s:default.= "%=%{% &showcmdloc == 'statusline' ? '%-10.S ' : '' %}"
let s:default.= "%{% exists('b:keymap_name') ? '<'..b:keymap_name..'> ' : '' %}"
let s:default.= "%{% &busy > 0 ? '◐ ' : '' %}"
let s:default.= "%(%{luaeval('(package.loaded[''vim.diagnostic''] and vim.diagnostic.status()) or '''' ')} %)"
let s:default.= "%{% &ruler ? ( &rulerformat == '' ? '%-14.(%l,%c%V%) %P' : &rulerformat ) : '' %}"

let s:left_sep = '🭛'

au User Screenkey* redrawstatus

function! vimline#statusline#() abort
  let l:ret = ''
  let l:state = state()
  let l:mode = mode()
  let [l:cwd, l:file] = path#relative_parts()

  let l:ret .= '%#Chromatophore_a# '
  let l:ret .= mode ==# 'n' ? ' ' : l:mode
  let l:ret .= state !=# '' ? '|'. state : ''
  let l:ret .= vimline#indicator#searchcount()
  let l:ret .= '%S '

  let l:ret .= '%#Chromatophore_ab#'
  let l:ret .= s:left_sep

  let l:ret .= '%#Chromatophore_b#'
  "let l:ret .= FugitiveStatusline()
  let l:ret .= ' 󱉭  '
  let l:ret .= l:cwd . '/'

  let l:ret .= '%#Chromatophore_bc#'
  let l:ret .= s:left_sep

  let l:ret .= '%#Chromatophore_c#'
  let l:ret .= l:file
  " let l:ret .= fnamemodify(expand('%'), ':.')

  " right-aligned
  let l:ret .= '%='
  let l:ret .= '%#Chromatophore_z#'
  let l:ret .= vimline#recording#()
  " let l:ret .= "%{v:lua.require'screenkey'.get_keys()}"

  return l:ret
endfunction
