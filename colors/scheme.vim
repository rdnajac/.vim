set background=dark
hi clear
if exists('syntax_on')
    syntax reset
endif
let g:colors_name = 'scheme'

let g:colors = {
    \ 'lightRed'        : ['#f2777a', '203'],
    \ 'lightViolet'     : ['#d09cea', '171'],
    \ 'lightYellow'     : ['#ffcc66', '222'],
    \ 'lightGreen'      : ['#99cc99', '108'],
    \ 'lightBlue'       : ['#6699cc', '67'],
    \ 'yellow'          : ['#ffbe3c', '215'],
    \ 'red'             : ['#f01d22', '160'],
    \ 'text'            : ['#cbcbcb', '251'],
    \ 'textDark'        : ['#bebebe', '249'],
    \ 'background'      : ['#000000', '0'],
    \ 'backgroundDark'  : ['#0f0f0f', '234'],
    \ 'backgroundLight' : ['#1f1f1f', '235'],
    \ 'comment'         : ['#6e6e6e', '242'],
    \ 'selected'        : ['#4c4c4c', '236'],
    \ 'cyan'            : ['#14AFFF', '14'],
    \ 'sea_green'       : ['SeaGreen', '121'],
    \ 'light_grey'      : ['LightGrey', '7'],
    \ 'grey_50'         : ['Grey50', '242'],
    \ 'white_15'        : ['White', '15'],
    \ 'error_red'       : ['Red', '160'],
    \ 'white'           : ['White', '15'],
    \ 'grey'            : ['Grey', '242'],
\ }

function! s:GetColor(color)
    return a:color == 'NONE' ? ['NONE', 'NONE'] : g:colors[a:color]
endfunction

function! s:Highlight(group, fgColor, ...)
    let bgColor = a:0 >= 3 ? a:2 : 'NONE'
    let fg = s:GetColor(a:fgColor)
    let bg = s:GetColor(bgColor)
    if fg[0] == 'NONE' && bg[0] == 'NONE'
        execute 'hi' a:group
    elseif fg[0] == 'NONE'
        execute 'hi' a:group 'guibg=' . bg[0] . ' ctermbg=' . bg[1]
    elseif bg[0] == 'NONE'
        execute 'hi' a:group 'guifg=' . fg[0] . ' ctermfg=' . fg[1]
    else
        execute 'hi' a:group
            \ 'guibg=' . bg[0] . ' guifg=' . fg[0] .
            \ ' ctermbg=' . bg[1] . ' ctermfg=' . fg[1]
    endif
endfunction

" Highlight groups
call s:Highlight('SpecialKey',    'backgroundLight', 'background')
call s:Highlight('NonText',       'white',           'background')
hi! link EndOfBuffer NonText

call s:Highlight('Directory',     'textDark',        'background')
call s:Highlight('ErrorMsg',      'text',            'red')
call s:Highlight('IncSearch',     'background',      'lightYellow')
call s:Highlight('Search',        'background',      'yellow')
hi! link CurSearch Search

call s:Highlight('MoreMsg',       'sea_green',       'background')
call s:Highlight('ModeMsg',       'yellow',          'background')
call s:Highlight('LineNr',        'lightYellow',     'background')
hi! link LineNrAbove NONE
hi! link LineNrBelow NONE
call s:Highlight('CursorLineNr',  'lightYellow',     'background')
hi! link CursorLineSign SignColumn
hi! link CursorLineFold FoldColumn

call s:Highlight('Question',      'lightGreen',      'background')
call s:Highlight('StatusLine',    'background',      'lightYellow')
call s:Highlight('StatusLineNC',  'text',            'backgroundLight')
call s:Highlight('VertSplit',     'yellow',          'background')
call s:Highlight('Title',         'lightRed',        'background')
call s:Highlight('Visual',        'selected',        'NONE')
" Only X11 Gui's |gui-x11| and |xterm-clipboard| supports this.
" call s:Highlight('VisualNOS',    'white',           'background')

call s:Highlight('WarningMsg',    'yellow',          'background')
call s:Highlight('WildMenu',      'yellow',          'background')

call s:Highlight('Folded',        'cyan',            'background')
call s:Highlight('FoldColumn',    'grey_50',         'background')
call s:Highlight('CursorColumn',  'grey',            'background')
"call s:Highlight('CursorLine',    'NONE',            'backgroundLight')
call s:Highlight('ColorColumn',   'background',      'yellow')
hi! link QuickFixLine Search
call s:Highlight('StatusLineTerm','background',      'black')
call s:Highlight('StatusLineTermNC','background',    'light_green')
hi! link MsgArea NONE
call s:Highlight('Normal',        'text',            'background')
call s:Highlight('MatchParen',    'background',      'yellow')

call s:Highlight('ToolbarLine',   'grey_50',         'background')
call s:Highlight('ToolbarButton', 'background',      'black')
call s:Highlight('Comment',       'comment',         'NONE')
call s:Highlight('Constant',      'lightRed',        'NONE')
call s:Highlight('Special',       'text',            'NONE')
call s:Highlight('Identifier',    'lightBlue',       'NONE')
call s:Highlight('Statement',     'lightYellow',     'NONE')
call s:Highlight('PreProc',       'lightViolet',     'NONE')
call s:Highlight('Type',          'textDark',        'NONE')
"call s:Highlight('Ignore',        'NONE')
call s:Highlight('Added',         'lightGreen',      'backgroundDark')
call s:Highlight('Changed',       'lightYellow',     'backgroundLight')
call s:Highlight('Removed',       'lightRed',        'backgroundDark')
call s:Highlight('Error',         'red',             'NONE')
call s:Highlight('Todo',          'yellow',          'NONE')

call s:Highlight('String',        'lightGreen',      'NONE')
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

call s:Highlight('Cursor',        'text',            'backgroundDark')
hi! link diffAdded DiffAdd
hi! link diffChanged DiffChange
hi! link diffRemoved DiffDelete

call s:Highlight('SignColumn',    'grey',            'background')
call s:Highlight('Conceal',       'backgroundLight', 'background')
call s:Highlight('SpellBad',      'error_red',       'NONE')
call s:Highlight('SpellCap',      'error_red',       'NONE')
call s:Highlight('SpellRare',     'error_red',       'NONE')
call s:Highlight('SpellLocal',    'error_red',       'NONE')

call s:Highlight('Pmenu',         'textDark',        'backgroundLight')
call s:Highlight('PmenuSel',      'text',            'background')
hi! link PmenuKind Pmenu
hi! link PmenuKindSel PmenuSel
hi! link PmenuExtra Pmenu
hi! link PmenuExtraSel PmenuSel
call s:Highlight('PmenuSbar',     'yellow',          'background')
call s:Highlight('PmenuThumb',    'white_15',        'background')

call s:Highlight('TabLine',       'textDark',        'backgroundLight')
call s:Highlight('TabLineSel',    'yellow',          'background')
call s:Highlight('TabLineFill',   'background',      'NONE')

