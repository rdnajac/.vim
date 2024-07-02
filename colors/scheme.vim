hi clear
if exists('syntax_on')
  syntax reset
endif
set background=dark
let g:colors_name = 'scheme'

" Color Palette
" =============
let s:black = '#000000'
let s:bg = s:black
let s:eigengrau = '#16161D'
let s:bg_visual = s:eigengrau

let s:fg = '#c0caf5'
let s:fg_dark = '#a9b1d6'
let s:fg_gutter = '#3b4261'

let s:tokyonight = '#24283b'

let s:blue = '#7aa2f7'
let s:blue1 = '#2ac3de'
let s:blue2 = '#0db9d7'
let s:blue5 = '#89ddff'
let s:chambray = '#545c7e'
let s:comment = '#565f89'
let s:cyan = '#14afff'
let s:dark5 = '#737aa2'
let s:green = '#9ece6a'
let s:green1 = '#73daca'
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
" Link Highlight Groups
" =============================================================================
" function that takes two args, the group to link against and a variable
" length array of groups to link to the first group

function! s:LinkGroups(base_highlight_group, ...)
  for element in a:000
    exec 'hi! link' element a:base_highlight_group
  endfor
endfunction


" =============================================================================
" Highlighting groups for various occasions
" =============================================================================
hi! link SpecialKey PreProc
" ColorColumn
call s:Highlight('Conceal', s:dark5, s:bg, '')
call s:Highlight('Cursor', s:fg, s:bg_visual, '')
call s:Highlight('CursorLine', 'NONE', s:bg_visual, '')
call s:Highlight('CursorLineNr', s:yellow, s:bg, 'bold')
call s:Highlight('CursorColumn', s:white, s:eigengrau, '')
" DiffAdd
" DiffChange
" DiffDelete
" DiffText
call s:Highlight('Directory', s:blue, s:bg, '')
call s:Highlight('ErrorMsg', s:red, s:bg, '')
" Ignore
call s:Highlight('FoldColumn', s:orange, s:bg, '')
call s:Highlight('Folded', s:blue, s:bg, '')
hi! link CursorLineFold FoldColumn
call s:Highlight('LineNr', s:fg_gutter, s:bg, '')
hi! link LineNrAbove NONE
hi! link LineNrBelow NONE
call s:Highlight('MsgArea', s:neongreen, s:eigengrau, '')
call s:Highlight('MoreMsg', s:blue, s:bg, '')
call s:Highlight('ModeMsg', s:yellow, s:bg, '')
call s:Highlight('Normal', s:white, s:bg, '')
call s:Highlight('Pmenu', s:fg, s:black, '')
call s:LinkGroups('Pmenu', 'PmenuExtra', 'PmenuKind')
call s:Highlight('PmenuSel', s:yellow, 'NONE', '')
call s:LinkGroups('PmenuSel', 'PmenuKindSel', 'PmenuExtraSel')
call s:Highlight('PmenuSbar', s:yellow, s:bg, '')
call s:Highlight('PmenuThumb', s:dark5, s:bg, '')
call s:Highlight('Question', s:green, s:bg, '')
call s:Highlight('SignColumn', s:fg_gutter, s:bg, '')
hi! link CursorLineSign SignColumn
call s:Highlight('Search', s:bg, s:yellow, 'bold')
call s:LinkGroups('Search', 'CurSearch', 'QuickFixLine', 'IncSearch')

call s:Highlight('MatchParen', s:magenta, s:neongreen, 'bold')

call s:LinkGroups('NonText', 'EndOfBuffer')
call s:Highlight('SpellBad', s:red, 'NONE', 'undercurl')
call s:Highlight('SpellCap', s:yellow, 'NONE', 'undercurl')
call s:Highlight('SpellRare', s:teal, 'NONE', 'undercurl')
call s:Highlight('SpellLocal', s:blue2, 'NONE', 'undercurl')
call s:Highlight('StatusLine', s:neongreen, s:black, 'bold')
call s:LinkGroups('StatusLine', 'StatusLineTerm', 'StatusLineNC', 'StatusLineTermNC')
call s:Highlight('TabLine', s:fg_gutter, s:black, '')
call s:Highlight('TabLineSel', s:blue, s:bg, 'bold')
call s:Highlight('TabLineFill', s:bg, 'NONE', '')
call s:Highlight('Title', s:blue, s:bg, 'bold')
call s:Highlight('ToolbarLine', s:chambray, s:bg, '')
call s:Highlight('ToolbarButton', s:cyan, s:bg, '')
call s:Highlight('VertSplit', s:yellow, s:bg, '')
call s:Highlight('Visual', s:yellow, s:tokyonight, '')
" VisualNOS
call s:Highlight('WarningMsg', s:yellow, s:bg, '')
call s:Highlight('WildMenu', s:yellow, 'NONE', '')

" =============================================================================
" Highlighting groups for language syntaxes
" =============================================================================

call s:Highlight('PreProc', s:blue1, 'NONE', '')
call s:Highlight('Constant', s:orange, 'NONE', '')
call s:Highlight('Statement', s:red, 'NONE', '')
call s:Highlight('Identifier', s:magenta, 'NONE', '')
call s:Highlight('Type', s:cyan, 'NONE', '')

call s:LinkGroups('PreProc', 'Define', 'Include', 'Macro', 'PreCondit')

call s:LinkGroups('Constant', 'Number', 'Boolean', 'Float')

call s:LinkGroups('Identifier', 'Function')
call s:LinkGroups('Statement', 'Conditional', 'Repeat', 'Label', 'Operator', 'Keyword', 'Exception')
call s:LinkGroups('Type', 'StorageClass', 'Structure', 'Typedef')
call s:Highlight('Comment', s:comment, 'NONE', 'italic')

call s:Highlight('String', s:neongreen, 'NONE', '')

call s:Highlight('Character', s:red, 'NONE', '')

" TODO change this to a different color
call s:Highlight('Special', s:blue, 'NONE', '')


call s:LinkGroups('Tag', 'SpecialChar', 'Delimiter', 'SpecialComment', 'Debug')

call s:Highlight('NonText', s:chambray, s:bg, '')

" Messages
call s:Highlight('Error', s:red, 'NONE', '')
call s:Highlight('Todo', s:black, s:yellow, 'bold')

call s:Highlight('Added', s:green1, s:tokyonight, '')
call s:Highlight('Changed', s:yellow, s:eigengrau, '')
call s:Highlight('Removed', s:red, s:tokyonight, '')


" =============================================================================
" Terminal Colors
" =============================================================================

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
