" Name:         scheme
" Description:  vim colorscheme inspired by tokyonight
" Author:       rdnajac

if has('nvim')
  " colorscheme tokyonight_generated
  let s:colors_dir = expand('<script>:p:h')
  execute 'source' s:colors_dir..'/tokyonight_generated.lua'
  hi link vimMap @keyword
  finish
endif

hi clear
if exists('syntax_on')
  syntax reset
endif
set background=dark
let g:colors_name = 'scheme'

" Color Palette
" =============
let s:black = '#000000'
let s:eigengrau = '#16161D'
let s:bg = s:black
let s:bg_alt = s:eigengrau

let s:fg = '#c0caf5'
" let s:fg_alt = '#3b4261'
let s:comment = '#565f89'
let s:fg_alt = s:comment
let s:fg_dark = '#a9b1d6'

let s:tokyonight = '#24283b'

let s:blue = '#7aa2f7'
let s:blue1 = '#2ac3de'
let s:blue2 = '#0db9d7'
let s:blue5 = '#89ddff'
let s:chambray = '#545c7e'
let s:cyan = '#14afff'
let s:dark5 = '#737aa2'
let s:green = '#9ece6a'
let s:green1 = '#73daca'
let s:pink= '#ff69ff'
let s:magenta = '#bb9af7'
let s:magenta2 = '#ff007c'
let s:neongreen = '#39ff14'
let s:orange = '#ff9e64'
let s:purple = '#9d7cd8'
let s:red = '#f7768e'
let s:red1 = '#db4b4b'
let s:teal = '#1abc9c'
let s:white = '#ffffff'
let s:yellow = '#e0af68'

" Highlighting functions
" =========================================
""
" Set and link highlight group colors
function! s:hi(group, fg, bg, ...) abort
  let l:attr = (a:0 > 0 && !empty(a:1)) ? a:1 : 'NONE'
  " Use highlight! to override existing settings
  execute printf(
	\ 'highlight! %s guifg=%s guibg=%s gui=%s cterm=%s',
	\ a:group, a:fg, a:bg, l:attr, l:attr
	\)
endfunction

""
" Link multiple highlight groups to a base group
" Accepts either a list or multiple arguments
function! s:link(base, ...) abort
  let l:groups = a:0 == 1 && type(a:1) == v:t_list ? a:1 : a:000
  for l:group in l:groups
    if !empty(l:group)
      " TODO: do I need to clear the group first?
      " execute 'highlight! clear' l:group
      execute 'highlight! link' l:group a:base
    endif
  endfor
endfunction

" Highlighting groups for various occasions
" =========================================
" Define the background in the normal group
call s:hi('Normal', s:white, s:bg, '')
call s:hi('Comment', s:comment, 'NONE', 'italic')

call s:hi('LineNr', s:fg_alt, s:bg, '')
" MsgArea = the command line area
call s:hi('MsgArea', s:neongreen, s:bg, '')

hi! link SpecialKey PreProc
" ColorColumn
call s:hi('Conceal', s:dark5, s:bg, '')
call s:hi('Cursor', s:fg, s:bg_alt, '')
call s:hi('CursorLine', 'NONE', s:bg_alt, '')
call s:hi('CursorLineNr', s:yellow, s:bg, 'bold')
call s:hi('CursorColumn', s:white, s:bg_alt, '')
" DiffAdd
" DiffChange
" DiffDelete
" DiffText
call s:hi('Directory', s:blue, s:bg, '')
call s:hi('ErrorMsg', s:red, s:bg, '')
" Ignore
call s:hi('FoldColumn', s:orange, s:bg, '')
call s:hi('Folded', s:blue, s:bg, '')
hi! link CursorLineFold FoldColumn
hi! link LineNrAbove NONE
hi! link LineNrBelow NONE

call s:hi('MoreMsg', s:blue, s:bg, '')
call s:hi('ModeMsg', s:yellow, s:bg, '')
call s:hi('Pmenu', s:fg, s:black, '')
call s:hi('PmenuSel', s:yellow, 'NONE', '')
call s:link('Pmenu', 'PmenuExtra', 'PmenuKind')
call  s:link('PmenuSel', 'PmenuKindSel', 'PmenuExtraSel')

call s:hi('PmenuSbar', s:yellow, s:bg, '')
call s:hi('PmenuThumb', s:dark5, s:bg, '')

call s:hi('Question', s:pink, s:bg, '')
call s:hi('SignColumn', s:fg_alt, s:bg, '')
hi! link CursorLineSign SignColumn

call s:hi('Search', s:bg, s:yellow, 'bold')
call s:link('Search', 'CurSearch', 'QuickFixLine', 'IncSearch', 'MatchParen')

" call s:hi(, s:magenta, s:neongreen, 'bold')

call s:link('NonText', 'EndOfBuffer')
call s:hi('SpellBad', s:red, 'NONE', 'undercurl')
call s:hi('SpellCap', s:yellow, 'NONE', 'undercurl')
call s:hi('SpellRare', s:teal, 'NONE', 'undercurl')
call s:hi('SpellLocal', s:blue2, 'NONE', 'undercurl')
call s:hi('StatusLine', s:neongreen, s:black, 'reverse')
call s:link('StatusLine', 'StatusLineTerm', 'StatusLineNC', 'StatusLineTermNC')
call s:hi('TabLine', s:fg_alt, 'NONE', '')
call s:hi('TabLineSel', s:neongreen, 'NONE', 'bold')
call s:hi('TabLineFill', 'NONE', s:bg, '')


call s:hi('Title', s:blue, s:bg, 'bold')
call s:hi('ToolbarLine', s:chambray, s:bg, '')
call s:hi('ToolbarButton', s:cyan, s:bg, '')
" this is meaningless if you turn off the vert fillchar
call s:hi('VertSplit', s:yellow, s:bg, '')
call s:hi('Visual', s:yellow, s:tokyonight, '')
" VisualNOS
call s:hi('WarningMsg', s:pink, s:bg, '')
call s:hi('WildMenu', s:pink, s:neongreen, '')

" extra
hi! link CursorIM Cursor
" hi! link HelpCommand Statement
" hi! link HelpExample Statement

" Highlighting groups for language syntaxes
" =========================================
call s:hi('Statement', s:red, 'NONE', '')
call s:link('Statement', 'Conditional', 'Repeat', 'Label', 'Operator', 'Keyword', 'Exception')

call s:hi('PreProc', s:blue1, 'NONE', '')
call s:link('PreProc', 'Define', 'Include', 'Macro', 'PreCondit')

call s:hi('Constant', s:orange, 'NONE', '')
call s:link('Constant', 'Number', 'Boolean', 'Float')

call s:hi('Identifier', s:magenta, 'NONE', '')
call s:link('Identifier', 'Function')

call s:hi('Type', s:cyan, 'NONE', '')
call s:link('Type', 'StorageClass', 'Structure', 'Typedef')

call s:hi('String', s:neongreen, 'NONE', '')

call s:hi('Character', s:red, 'NONE', '')

call s:hi('Delimiter', s:magenta2, 'NONE', '')
call s:hi('Special', s:teal, 'NONE', '')
call s:link('Special', 'Tag', 'SpecialChar', 'SpecialComment', 'Debug')

call s:hi('NonText', s:chambray, s:bg, '')

" Messages
call s:hi('Error', 'NONE', s:red, '')
call s:hi('Todo', s:black, s:yellow, 'bold')

call s:hi('Added', s:green1, s:tokyonight, '')
call s:hi('Changed', s:yellow, s:eigengrau, '')
call s:hi('Removed', s:red, s:tokyonight, '')

" Highlighting groups for VimL
" ============================
call s:hi('vimFuncSID', s:blue, 'NONE', '')

" Terminal Colors
" ===============
let g:terminal_color_0 = s:black
let g:terminal_color_1 = s:red
let g:terminal_color_2 = s:green
let g:terminal_color_3 = s:yellow
let g:terminal_color_4 = s:blue
let g:terminal_color_5 = s:magenta
let g:terminal_color_6 = s:cyan
let g:terminal_color_7 = s:fg_dark
let g:terminal_color_8 = s:black
let g:terminal_color_9 = s:red
let g:terminal_color_10 = s:green
let g:terminal_color_11 = s:yellow
let g:terminal_color_12 = s:blue
let g:terminal_color_13 = s:magenta
let g:terminal_color_14 = s:cyan
let g:terminal_color_15 = s:fg
