" =============================================================================
" Filename:    tokyomidnight.vim
" Maintainer:  Ryan D. Najac
" License:     Public Domain
" Description: A Vim color scheme based on tokyonight-night by folke.
"              See https://github.com/folke/tokyonight.nvim for the original.
" Last Change: 2024-05-20
" =============================================================================

hi clear
if exists('syntax_on')
  syntax reset
endif
set background=dark
let g:colors_name = 'tokyomidnight'

" =============================================================================
" Color Palette
" =============================================================================

let s:bg_dark = '#1f2335'
let s:bg = '#000000'
let s:eigengrau = '#16161d'
let s:fg = '#c0caf5'
let s:fg_dark = '#a9b1d6'
let s:fg_gutter = '#3b4261'
let s:chambray = '#545c7e'
let s:comment = '#565f89'
let s:dark5 = '#737aa2'
let s:mariner = '#3d59a1'
let s:blue = '#7aa2f7'
let s:cyan = '#7dcfff'
let s:blue1 = '#2ac3de'
let s:blue2 = '#0db9d7'
let s:blue5 = '#89ddff'
let s:magenta = '#bb9af7'
let s:magenta2 = '#ff007c'
let s:purple = '#9d7cd8'
let s:orange = '#ff9e64'
let s:yellow = '#e0af68'
let s:green = '#9ece6a'
let s:green1 = '#73daca'
let s:teal = '#1abc9c'
let s:red = '#f7768e'
let s:red1 = '#db4b4b'
let s:white = '#ffffff'
let s:fg_sidebar = s:fg_dark
let s:bg_statusline = s:bg_dark
let s:bg_visual = s:mariner
let s:bg_popup = s:bg_dark

" =============================================================================
" Git Colors
" =============================================================================
let s:git_change = '#6183bb'
let s:git_add = '#449dab'
let s:git_delete = '#914c54'
let s:gitSigns_add = '#266d6a'
let s:gitSigns_change = '#536c9e'
let s:gitSigns_delete = '#b2555b'

" =============================================================================
" Highlight function
" =============================================================================

function! s:Highlight(group, fg, bg, attr)
  if a:attr != ''
    exec 'hi' a:group 'guifg=' . a:fg 'guibg=' . a:bg 'gui=' . a:attr
  else
    exec 'hi' a:group 'guifg=' . a:fg 'guibg=' . a:bg
  endif
endfunction

" =============================================================================
" Highlight Groups
" =============================================================================

call s:Highlight('SpecialKey', s:chambray, s:bg, '')
call s:Highlight('NonText', s:chambray, s:bg, '')
hi! link EndOfBuffer NonText

call s:Highlight('Directory', s:blue, s:bg, '')
call s:Highlight('ErrorMsg', s:red, s:bg, '')
call s:Highlight('IncSearch', s:bg, s:yellow, '')
call s:Highlight('Search', s:bg, s:yellow, '')
hi! link CurSearch Search

call s:Highlight('MoreMsg', s:blue, s:bg, '')
call s:Highlight('ModeMsg', s:yellow, s:bg, '')
call s:Highlight('LineNr', s:fg_gutter, s:bg, '')
hi! link LineNrAbove NONE
hi! link LineNrBelow NONE
call s:Highlight('CursorLine', 'NONE', s:eigengrau, '')
call s:Highlight('CursorLineNr', s:yellow, s:bg, 'bold')
hi! link CursorLineSign SignColumn
hi! link CursorLineFold FoldColumn

call s:Highlight('Question', s:green, s:bg, '')
call s:Highlight('StatusLine', s:fg_sidebar, s:bg_statusline, '')
call s:Highlight('StatusLineNC', s:fg_gutter, s:bg_statusline, '')
call s:Highlight('VertSplit', s:yellow, s:bg, '')
call s:Highlight('Title', s:blue, s:bg, 'bold')
call s:Highlight('Visual', s:bg_visual, 'NONE', '')

call s:Highlight('WarningMsg', s:yellow, s:bg, '')
call s:Highlight('WildMenu', s:bg_visual, 'NONE', '')

call s:Highlight('Folded', s:blue, s:fg_gutter, '')
call s:Highlight('FoldColumn', s:comment, s:bg, '')
call s:Highlight('CursorColumn', s:white, s:eigengrau, '')
hi! link QuickFixLine Search
call s:Highlight('StatusLineTerm', s:fg_sidebar, s:bg, '')
call s:Highlight('StatusLineTermNC', s:green1, s:bg, '')
hi! link MsgArea NONE
call s:Highlight('Normal', s:fg, s:bg, '')
call s:Highlight('MatchParen', s:bg, s:yellow, 'bold')

call s:Highlight('ToolbarLine', s:chambray, s:bg, '')
call s:Highlight('ToolbarButton', s:bg, s:bg, '')
call s:Highlight('Comment', s:comment, 'NONE', 'italic')
call s:Highlight('Constant', s:orange, 'NONE', '')
call s:Highlight('Special', s:fg, 'NONE', '')
call s:Highlight('Identifier', s:magenta, 'NONE', '')
call s:Highlight('Statement', s:magenta, 'NONE', '')
call s:Highlight('PreProc', s:cyan, 'NONE', '')
call s:Highlight('Type', s:blue1, 'NONE', '')
call s:Highlight('Added', s:green1, s:bg_dark, '')
call s:Highlight('Changed', s:yellow, s:eigengrau, '')
call s:Highlight('Removed', s:red, s:bg_dark, '')
call s:Highlight('Error', s:red, 'NONE', '')
call s:Highlight('Todo', s:bg, s:yellow, '')

call s:Highlight('String', s:green, 'NONE', '')
hi! link Character String
hi! link Number Constant
hi! link Boolean Constant
hi! link Float Number
hi! link Function Identifier
hi! link Conditional Statement
hi! link Repeat Statement
hi! link Label Statement
hi! link Operator Statement
hi! link Keyword Statement
hi! link Exception Statement
hi! link Include PreProc
hi! link Define PreProc
hi! link Macro PreProc
hi! link PreCondit PreProc
hi! link StorageClass Type
hi! link Structure Type
hi! link Typedef Type
hi! link Tag Special
hi! link SpecialChar Special
hi! link Delimiter Special
hi! link SpecialComment Special
hi! link Debug Special

call s:Highlight('Cursor', s:fg, s:bg_dark, '')
hi! link diffAdded DiffAdd
hi! link diffChanged DiffChange
hi! link diffRemoved DiffDelete

call s:Highlight('SignColumn', s:fg_gutter, s:bg, '')
call s:Highlight('Conceal', s:dark5, s:bg, '')
call s:Highlight('SpellBad', s:red, 'NONE', 'undercurl')
call s:Highlight('SpellCap', s:yellow, 'NONE', 'undercurl')
call s:Highlight('SpellRare', s:teal, 'NONE', 'undercurl')
call s:Highlight('SpellLocal', s:blue2, 'NONE', 'undercurl')

call s:Highlight('Pmenu', s:fg, s:bg_popup, '')
call s:Highlight('PmenuSel', s:fg_gutter, 'NONE', '')
hi! link PmenuKind Pmenu
hi! link PmenuKindSel PmenuSel
hi! link PmenuExtra Pmenu
hi! link PmenuExtraSel PmenuSel
call s:Highlight('PmenuSbar', s:yellow, s:bg, '')
call s:Highlight('PmenuThumb', s:dark5, s:bg, '')

call s:Highlight('TabLine', s:fg_gutter, s:bg_statusline, '')
call s:Highlight('TabLineSel', s:blue, s:bg, 'bold')
call s:Highlight('TabLineFill', s:bg, 'NONE', '')

" =============================================================================
" Terminal Colors
" =============================================================================

let g:terminal_color_0 = s:bg
let g:terminal_color_1 = s:red
let g:terminal_color_2 = s:green
let g:terminal_color_3 = s:yellow
let g:terminal_color_4 = s:blue
let g:terminal_color_5 = s:magenta
let g:terminal_color_6 = s:cyan
let g:terminal_color_7 = s:fg_dark
let g:terminal_color_8 = s:bg
let g:terminal_color_9 = s:red
let g:terminal_color_10 = s:green
let g:terminal_color_11 = s:yellow
let g:terminal_color_12 = s:blue
let g:terminal_color_13 = s:magenta
let g:terminal_color_14 = s:cyan
let g:terminal_color_15 = s:fg

