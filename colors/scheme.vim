set background=dark
hi clear
if exists('syntax_on')
    syntax reset
endif
let g:colors_name = 'scheme'

let g:colors = {
    \ 'red': ['#f2777a', '203'],
    \ 'purple': ['#d09cea', '171'],
    \ 'orange': ['#ffcc66', '222'],
    \ 'green': ['#99cc99', '108'],
    \ 'grey': ['#6e6e6e', '242'],
    \ 'yellow': ['#ffbe3c', '215'],
    \ 'bg': ['#000000', '0'],
    \ 'black': ['#000000', '0'],
    \ 'text_light': ['#cbcbcb', '251'],
    \ 'text_dark': ['#bebebe', '249'],
    \ 'error_red': ['#f01d22', '160'],
    \ 'blue': ['#6699cc', '67'],
    \ 'white': ['#ebebeb', '255'],
    \ 'cyan': ['#14AFFF', '14'],
    \ 'sea_green': ['SeaGreen', '121'],
    \ 'light_grey': ['LightGrey', '7'],
    \ 'black_0': ['Black', '0'],
    \ 'light_green': ['LightGreen', '121'],
    \ 'grey_50': ['Grey50', '242'],
    \ 'white_15': ['White', '15'],
\ }

function! s:Highlight(group, fgColor)
    let fg = a:fgColor == 'NONE' ? 'NONE' : g:colors[a:fgColor][0]
    let bg = g:colors['bg'][0]
    let ctermfg = a:fgColor == 'NONE' ? 'NONE' : g:colors[a:fgColor][1]
    let ctermbg = g:colors['bg'][1]
    execute 'hi' a:group 'guibg=' . bg . ' guifg=' . fg . ' ctermbg=' . ctermbg . ' ctermfg=' . ctermfg
endfunction

" Highlight groups
call s:Highlight('SpecialKey', 'bg')
call s:Highlight('NonText', 'white')
hi! link EndOfBuffer NonText

call s:Highlight('Directory', 'text_dark')
call s:Highlight('ErrorMsg', 'error_red')
call s:Highlight('IncSearch', 'orange')
call s:Highlight('Search', 'yellow')
hi! link CurSearch Search

call s:Highlight('MoreMsg', 'sea_green')
call s:Highlight('ModeMsg', 'yellow')
call s:Highlight('LineNr', 'orange')
hi! link LineNrAbove NONE
hi! link LineNrBelow NONE
call s:Highlight('CursorLineNr', 'orange')
hi! link CursorLineSign SignColumn
hi! link CursorLineFold FoldColumn

call s:Highlight('Question', 'green')
call s:Highlight('StatusLine', 'yellow')
call s:Highlight('StatusLineNC', 'text_light')
call s:Highlight('VertSplit', 'yellow')
call s:Highlight('Title', 'red')
call s:Highlight('Visual', 'white')
call s:Highlight('VisualNOS', 'white')
call s:Highlight('WarningMsg', 'yellow')
call s:Highlight('WildMenu', 'yellow')

call s:Highlight('Folded', 'cyan')
call s:Highlight('FoldColumn', 'grey')
call s:Highlight('CursorColumn', 'grey')
call s:Highlight('CursorLine', 'NONE')
call s:Highlight('ColorColumn', 'yellow')
hi! link QuickFixLine Search
call s:Highlight('StatusLineTerm', 'black')
call s:Highlight('StatusLineTermNC', 'light_green')
hi! link MsgArea NONE
call s:Highlight('Normal', 'text_light')
call s:Highlight('MatchParen', 'yellow')

call s:Highlight('ToolbarLine', 'grey_50')
call s:Highlight('ToolbarButton', 'black')
call s:Highlight('Comment', 'grey')
call s:Highlight('Constant', 'red')
call s:Highlight('Special', 'white')
call s:Highlight('Identifier', 'blue')
call s:Highlight('Statement', 'orange')
call s:Highlight('PreProc', 'purple')
call s:Highlight('Type', 'text_dark')
call s:Highlight('Ignore', 'NONE')
call s:Highlight('Added', 'green')
call s:Highlight('Changed', 'orange')
call s:Highlight('Removed', 'red')
call s:Highlight('Error', 'error_red')
call s:Highlight('Todo', 'yellow')

call s:Highlight('String', 'green')
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

call s:Highlight('Cursor', 'text_light')
hi! link diffAdded DiffAdd
hi! link diffChanged DiffChange
hi! link diffRemoved DiffDelete

call s:Highlight('SignColumn', 'grey')
call s:Highlight('Conceal', 'bg')
call s:Highlight('SpellBad', 'error_red')
call s:Highlight('SpellCap', 'error_red')
call s:Highlight('SpellRare', 'error_red')
call s:Highlight('SpellLocal', 'error_red')

call s:Highlight('Pmenu', 'text_dark')
call s:Highlight('PmenuSel', 'text_light')
hi! link PmenuKind Pmenu
hi! link PmenuKindSel PmenuSel
hi! link PmenuExtra Pmenu
hi! link PmenuExtraSel PmenuSel
call s:Highlight('PmenuSbar', 'yellow')
call s:Highlight('PmenuThumb', 'white_15')

call s:Highlight('TabLine', 'text_dark')
call s:Highlight('TabLineSel', 'yellow')
call s:Highlight('TabLineFill', 'bg')
