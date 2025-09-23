" Name:         scheme
" Description:  vim colorscheme inspired by tokyonight
" Author:       rdnajac

" TODO: check out kyza0d/xeno.nvim
if has('nvim')
  " && luaeval('package.loaded["tokyonight"] ~= nil')
   lua require('nvim.tokyonight').after()
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

" Highlighting groups for various occasions
" =========================================
" Define the background in the normal group
call vim#hl#set('Normal', s:white, s:bg, '')
call vim#hl#set('Comment', s:comment, 'NONE', 'italic')

call vim#hl#set('LineNr', s:fg_alt, s:bg, '')
" MsgArea = the command line area
call vim#hl#set('MsgArea', s:neongreen, s:bg, '')

hi! link SpecialKey PreProc
" ColorColumn
call vim#hl#set('Conceal', s:dark5, s:bg, '')
call vim#hl#set('Cursor', s:fg, s:bg_alt, '')
call vim#hl#set('CursorLine', 'NONE', s:bg_alt, '')
call vim#hl#set('CursorLineNr', s:yellow, s:bg, 'bold')
call vim#hl#set('CursorColumn', s:white, s:bg_alt, '')
" DiffAdd
" DiffChange
" DiffDelete
" DiffText
call vim#hl#set('Directory', s:blue, s:bg, '')
call vim#hl#set('ErrorMsg', s:red, s:bg, '')
" Ignore
call vim#hl#set('FoldColumn', s:orange, s:bg, '')
call vim#hl#set('Folded', s:blue, s:bg, '')
hi! link CursorLineFold FoldColumn
hi! link LineNrAbove NONE
hi! link LineNrBelow NONE

call vim#hl#set('MoreMsg', s:blue, s:bg, '')
call vim#hl#set('ModeMsg', s:yellow, s:bg, '')
call vim#hl#set('Pmenu', s:fg, s:black, '')
call vim#hl#set('PmenuSel', s:yellow, 'NONE', '')
call vim#hl#link('Pmenu', 'PmenuExtra', 'PmenuKind')
call vim#hl#link('PmenuSel', 'PmenuKindSel', 'PmenuExtraSel')

call vim#hl#set('PmenuSbar', s:yellow, s:bg, '')
call vim#hl#set('PmenuThumb', s:dark5, s:bg, '')

call vim#hl#set('Question', s:pink, s:bg, '')
call vim#hl#set('SignColumn', s:fg_alt, s:bg, '')
hi! link CursorLineSign SignColumn

call vim#hl#set('Search', s:bg, s:yellow, 'bold')
call vim#hl#link('Search', 'CurSearch', 'QuickFixLine', 'IncSearch', 'MatchParen')

" call vim#hl#set(, s:magenta, s:neongreen, 'bold')

call vim#hl#link('NonText', 'EndOfBuffer')
call vim#hl#set('SpellBad', s:red, 'NONE', 'undercurl')
call vim#hl#set('SpellCap', s:yellow, 'NONE', 'undercurl')
call vim#hl#set('SpellRare', s:teal, 'NONE', 'undercurl')
call vim#hl#set('SpellLocal', s:blue2, 'NONE', 'undercurl')
call vim#hl#set('StatusLine', s:neongreen, s:black, 'reverse')
call vim#hl#link('StatusLine', 'StatusLineTerm', 'StatusLineNC', 'StatusLineTermNC')
call vim#hl#set('TabLine', s:fg_alt, 'NONE', '')
call vim#hl#set('TabLineSel', s:neongreen, 'NONE', 'bold')
call vim#hl#set('TabLineFill', 'NONE', s:bg, '')


call vim#hl#set('Title', s:blue, s:bg, 'bold')
call vim#hl#set('ToolbarLine', s:chambray, s:bg, '')
call vim#hl#set('ToolbarButton', s:cyan, s:bg, '')
" this is meaningless if you turn off the vert fillchar
call vim#hl#set('VertSplit', s:yellow, s:bg, '')
call vim#hl#set('Visual', s:yellow, s:tokyonight, '')
" VisualNOS
call vim#hl#set('WarningMsg', s:pink, s:bg, '')
call vim#hl#set('WildMenu', s:pink, s:neongreen, '')

" extra
hi! link CursorIM Cursor
" hi! link HelpCommand Statement
" hi! link HelpExample Statement

" Highlighting groups for language syntaxes
" =========================================
call vim#hl#set('Statement', s:red, 'NONE', '')
call vim#hl#link('Statement', 'Conditional', 'Repeat', 'Label', 'Operator', 'Keyword', 'Exception')

call vim#hl#set('PreProc', s:blue1, 'NONE', '')
call vim#hl#link('PreProc', 'Define', 'Include', 'Macro', 'PreCondit')

call vim#hl#set('Constant', s:orange, 'NONE', '')
call vim#hl#link('Constant', 'Number', 'Boolean', 'Float')

call vim#hl#set('Identifier', s:magenta, 'NONE', '')
call vim#hl#link('Identifier', 'Function')

call vim#hl#set('Type', s:cyan, 'NONE', '')
call vim#hl#link('Type', 'StorageClass', 'Structure', 'Typedef')

call vim#hl#set('String', s:neongreen, 'NONE', '')

call vim#hl#set('Character', s:red, 'NONE', '')

call vim#hl#set('Delimiter', s:magenta2, 'NONE', '')
call vim#hl#set('Special', s:teal, 'NONE', '')
call vim#hl#link('Special', 'Tag', 'SpecialChar', 'SpecialComment', 'Debug')

call vim#hl#set('NonText', s:chambray, s:bg, '')

" Messages
call vim#hl#set('Error', 'NONE', s:red, '')
call vim#hl#set('Todo', s:black, s:yellow, 'bold')

call vim#hl#set('Added', s:green1, s:tokyonight, '')
call vim#hl#set('Changed', s:yellow, s:eigengrau, '')
call vim#hl#set('Removed', s:red, s:tokyonight, '')

" Highlighting groups for VimL
" ============================
call vim#hl#set('vimFuncSID', s:blue, 'NONE', '')

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
