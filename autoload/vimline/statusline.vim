scriptencoding utf-8

let s:default = "%<%f %h%w%m%r "
let s:default.= "%=%{% &showcmdloc == 'statusline' ? '%-10.S ' : '' %}"
let s:default.= "%{% exists('b:keymap_name') ? '<'..b:keymap_name..'> ' : '' %}"
let s:default.= "%{% &busy > 0 ? '◐ ' : '' %}"
let s:default.= "%(%{luaeval('(package.loaded[''vim.diagnostic''] and vim.diagnostic.status()) or '''' ')} %)"
let s:default.= "%{% &ruler ? ( &rulerformat == '' ? '%-14.(%l,%c%V%) %P' : &rulerformat ) : '' %}"

let s:left_sep = '🭛'

" au User Screenkey* redrawstatus

function! vimline#statusline#() abort
  let ret = ''
  let state = state()
  let mode = mode()
  let [cwd, file] = vimline#path#relative_parts()

  let ret .= '%#Chromatophore_a# '
  let ret .= mode ==# 'n' ? ' ' : mode
  let ret .= state !=# '' ? '|'. state : ''
  let ret .= vimline#indicator#searchcount()
  let ret .= '%S '

  let ret .= '%#Chromatophore_ab#'
  let ret .= s:left_sep

  let ret .= '%#Chromatophore_b#'
  "let ret .= FugitiveStatusline()
  let ret .= ' 󱉭  '
  let ret .= cwd . '/'

  let ret .= '%#Chromatophore_bc#'
  let ret .= s:left_sep

  let ret .= '%#Chromatophore_c#'
  let ret .= file
  " let ret .= fnamemodify(expand('%'), ':.')

  " right-aligned
  let ret .= '%='
  let ret .= '%#Chromatophore_z#'
  let ret .= vimline#recording#()
  " let ret .= "%{v:lua.require'screenkey'.get_keys()}"

  return ret
endfunction
