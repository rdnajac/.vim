local opts = { transparent = true }
local c = require('nvim.tokyonight.colors').colors
local Blend_bg = require('nvim.tokyonight.colors').Blend_bg
local Blend_fg = require('nvim.tokyonight.colors').Blend_fg

local M = {
  base = {
    Foo = { bg = c.magenta2, fg = c.fg },

    Comment = { fg = c.comment, italic = true }, -- any comment
    Function = { fg = c.blue }, -- function name (also: methods for classes)
    Identifier = { fg = c.magenta }, -- (preferred) any variable name
    Keyword = { fg = c.cyan, bold = true }, --  any other keyword

    Normal = { fg = c.fg, bg = opts.transparent and c.none or c.bg }, -- normal text
    NormalNC = { fg = c.fg, bg = opts.transparent and c.none or c.bg_dark }, -- normal text in non-current windows `ALWAYS DIM INACTIVE`
    FoldColumn = { bg = opts.transparent and c.none or c.bg, fg = c.comment }, -- 'foldcolumn'
    SignColumn = { bg = opts.transparent and c.none or c.bg, fg = c.fg_gutter }, -- column where |signs| are displayed
    TabLineFill = { bg = opts.transparent and c.none or c.black }, -- tab pages line, where there are no labels
    TabLine = { bg = c.bg_statusline, fg = c.fg_gutter }, -- tab pages line, not active tab page label
    TabLineSel = { fg = c.black, bg = c.blue }, -- tab pages line, active tab page label

    ColorColumn = { bg = c.black }, -- used for the columns set with 'colorcolumn'
    Conceal = { fg = c.dark5 }, -- placeholder characters substituted for concealed text (see 'conceallevel')
    Cursor = { fg = c.bg, bg = c.fg }, -- character under the cursor
    lCursor = { fg = c.bg, bg = c.fg }, -- the character under the cursor when |language-mapping| is used (see 'guicursor')
    CursorIM = { fg = c.bg, bg = c.fg }, -- like Cursor, but used when in IME mode |CursorIM|
    CursorColumn = { bg = c.bg_highlight }, -- Screen-column at the cursor, when 'cursorcolumn' is set.
    CursorLine = { bg = c.bg_highlight }, -- Screen-line at the cursor, when 'cursorline' is set.  Low-priority if foreground (ctermfg OR guifg) is not set.
    Directory = { fg = c.blue }, -- directory names (and other special names in listings)
    DiffAdd = { bg = c.diff.add }, -- diff mode: Added line |diff.txt|
    DiffChange = { bg = c.diff.change }, -- diff mode: Changed line |diff.txt|
    DiffDelete = { bg = c.diff.delete }, -- diff mode: Deleted line |diff.txt|
    DiffText = { bg = c.diff.text }, -- diff mode: Changed text within a changed line |diff.txt|
    EndOfBuffer = { fg = c.bg }, -- filler lines (~) after the end of the buffer.  By default, this is highlighted like |hl-NonText|.
    ErrorMsg = { fg = c.error }, -- error messages on the command line
    VertSplit = { fg = c.border }, -- the column separating vertically split windows
    WinSeparator = { fg = c.border, bold = true }, -- the column separating vertically split windows
    Folded = { fg = c.blue, bg = c.fg_gutter }, -- line used for closed folds
    SignColumnSB = { bg = c.bg_sidebar, fg = c.fg_gutter }, -- column where |signs| are displayed
    Substitute = { bg = c.red, fg = c.black }, -- |:substitute| replacement text highlighting
    LineNr = { fg = c.fg_gutter }, -- Line number for ":number" and ":#" commands, and when 'number' or 'relativenumber' option is set.
    CursorLineNr = { fg = c.orange, bold = true }, -- Like LineNr when 'cursorline' or 'relativenumber' is set for the cursor line.
    LineNrAbove = { fg = c.fg_gutter },
    LineNrBelow = { fg = c.fg_gutter },
    MatchParen = { fg = c.orange, bold = true }, -- The character under the cursor or just before it, if it is a paired bracket, and its match. |pi_paren.txt|
    ModeMsg = { fg = c.fg_dark, bold = true }, -- 'showmode' message (e.g., "-- INSERT -- ")
    MsgArea = { fg = c.fg_dark }, -- Area for messages and cmdline
    MoreMsg = { fg = c.blue }, -- |more-prompt|
    NonText = { fg = c.dark3 }, -- '@' at the end of the window, characters from 'showbreak' and other characters that do not really exist in the text (e.g., ">" displayed when a double-wide character doesn't fit at the end of the line). See also |hl-EndOfBuffer|.
    NormalSB = { fg = c.fg_sidebar, bg = c.bg_sidebar }, -- normal text in sidebar
    NormalFloat = { fg = c.fg_float, bg = c.bg_float }, -- Normal text in floating windows.
    -- Number                      = { fg = c.blue },
    FloatBorder = { fg = c.border_highlight, bg = c.bg_float },
    FloatTitle = { fg = c.border_highlight, bg = c.bg_float },
    Pmenu = { bg = c.bg_popup, fg = c.fg }, -- Popup menu: normal item.
    PmenuMatch = { bg = c.bg_popup, fg = c.blue1 }, -- Popup menu: Matched text in normal item.
    PmenuSel = { bg = Blend_bg(c.fg_gutter, 0.8) }, -- Popup menu: selected item.
    PmenuMatchSel = { bg = Blend_bg(c.fg_gutter, 0.8), fg = c.blue1 }, -- Popup menu: Matched text in selected item.
    PmenuSbar = { bg = Blend_fg(c.bg_popup, 0.95) }, -- Popup menu: scrollbar.
    PmenuThumb = { bg = c.fg_gutter }, -- Popup menu: Thumb of the scrollbar.
    Question = { fg = c.blue }, -- |hit-enter| prompt and yes/no questions
    QuickFixLine = { bg = c.bg_visual, bold = true }, -- Current |quickfix| item in the quickfix window. Combined with |hl-CursorLine| when the cursor is there.
    Search = { bg = c.bg_search, fg = c.fg }, -- Last search pattern highlighting (see 'hlsearch').  Also used for similar items that need to stand out.
    IncSearch = { bg = c.orange, fg = c.black }, -- 'incsearch' highlighting; also used for the text replaced with ":s///c"
    CurSearch = 'IncSearch',
    SpecialKey = { fg = c.dark3 }, -- Unprintable characters: text displayed differently from what it really is.  But not 'listchars' whitespace. |hl-Whitespace|
    SpellBad = { sp = c.error, undercurl = true }, -- Word that is not recognized by the spellchecker. |spell| Combined with the highlighting used otherwise.
    SpellCap = { sp = c.warning, undercurl = true }, -- Word that should start with a capital. |spell| Combined with the highlighting used otherwise.
    SpellLocal = { sp = c.info, undercurl = true }, -- Word that is recognized by the spellchecker as one that is used in another region. |spell| Combined with the highlighting used otherwise.
    SpellRare = { sp = c.hint, undercurl = true }, -- Word that is recognized by the spellchecker as one that is hardly ever used.  |spell| Combined with the highlighting used otherwise.
    StatusLine = { fg = c.fg_sidebar, bg = c.bg_statusline }, -- status line of current window
    StatusLineNC = { fg = c.fg_gutter, bg = c.bg_statusline }, -- status lines of not-current windows Note: if this is equal to "StatusLine" Vim will use "^^^" in the status line of the current window.
    Title = { fg = c.blue, bold = true }, -- titles for output from ":set all", ":autocmd" etc.
    Visual = { bg = c.bg_visual }, -- Visual mode selection
    VisualNOS = { bg = c.bg_visual }, -- Visual mode selection when vim is "Not Owning the Selection".
    WarningMsg = { fg = c.warning }, -- warning messages
    Whitespace = { fg = c.fg_gutter }, -- "nbsp", "space", "tab" and "trail" in 'listchars'
    WildMenu = { bg = c.bg_visual }, -- current match in 'wildmenu' completion
    WinBar = 'StatusLine', -- window bar
    WinBarNC = 'StatusLineNC', -- window bar in inactive windows

    Bold = { bold = true, fg = c.fg }, -- (preferred) any bold text
    Character = { fg = c.green }, --  a character constant: 'c', '\n'
    Constant = { fg = c.orange }, -- (preferred) any constant
    Debug = { fg = c.orange }, --    debugging statements
    Delimiter = 'Special', --  character that needs attention
    Error = { fg = c.error }, -- (preferred) any erroneous construct
    Italic = { italic = true, fg = c.fg }, -- (preferred) any italic text
    Operator = { fg = c.blue5 }, -- "sizeof", "+", "*", etc.
    PreProc = { fg = c.cyan }, -- (preferred) generic Preprocessor
    Special = { fg = c.blue1, bold = true }, -- (preferred) any special symbol
    Statement = { fg = c.red }, -- (preferred) any statement
    String = { fg = c.green }, --   a string constant: "this is a string"
    Todo = { bg = c.yellow, fg = c.bg }, -- (preferred) anything that needs extra attention; mostly the keywords TODO FIXME and XXX
    Type = { fg = c.blue1 }, -- (preferred) int, long, char, etc.
    Underlined = { underline = true }, -- (preferred) text that stands out, HTML links
    debugBreakpoint = { bg = Blend_bg(c.info, 0.1), fg = c.info }, -- used for breakpoint colors in terminal-debug
    debugPC = { bg = c.bg_sidebar }, -- used for highlighting the current line in terminal-debug
    dosIniLabel = '@property',
    helpCommand = { bg = c.terminal_black, fg = c.blue },
    htmlH1 = { fg = c.magenta, bold = true },
    htmlH2 = { fg = c.blue, bold = true },
    qfFileName = { fg = c.blue },
    qfLineNr = { fg = c.dark5 },

    -- These groups are for the native LSP client. Some other LSP clients may
    -- use these groups, or use their own.
    LspReferenceText = { bg = c.fg_gutter }, -- used for highlighting "text" references
    LspReferenceRead = { bg = c.fg_gutter }, -- used for highlighting "read" references
    LspReferenceWrite = { bg = c.fg_gutter }, -- used for highlighting "write" references
    LspSignatureActiveParameter = { bg = Blend_bg(c.bg_visual, 0.4), bold = true },
    LspCodeLens = { fg = c.comment },
    LspInlayHint = { bg = Blend_bg(c.blue7, 0.1), fg = c.dark3 },
    LspInfoBorder = { fg = c.border_highlight, bg = c.bg_float },
    ComplHint = { fg = c.terminal_black },

    -- diagnostics
    DiagnosticError = { fg = c.error }, -- Used as the base highlight group. Other Diagnostic highlights link to this by default
    DiagnosticWarn = { fg = c.warning }, -- Used as the base highlight group. Other Diagnostic highlights link to this by default
    DiagnosticInfo = { fg = c.info }, -- Used as the base highlight group. Other Diagnostic highlights link to this by default
    DiagnosticHint = { fg = c.hint }, -- Used as the base highlight group. Other Diagnostic highlights link to this by default
    DiagnosticUnnecessary = { fg = c.terminal_black }, -- Used as the base highlight group. Other Diagnostic highlights link to this by default
    DiagnosticVirtualTextError = { bg = Blend_bg(c.error, 0.1), fg = c.error }, -- Used for "Error" diagnostic virtual text
    DiagnosticVirtualTextWarn = { bg = Blend_bg(c.warning, 0.1), fg = c.warning }, -- Used for "Warning" diagnostic virtual text
    DiagnosticVirtualTextInfo = { bg = Blend_bg(c.info, 0.1), fg = c.info }, -- Used for "Information" diagnostic virtual text
    DiagnosticVirtualTextHint = { bg = Blend_bg(c.hint, 0.1), fg = c.hint }, -- Used for "Hint" diagnostic virtual text
    DiagnosticUnderlineError = { undercurl = true, sp = c.error }, -- Used to underline "Error" diagnostics
    DiagnosticUnderlineWarn = { undercurl = true, sp = c.warning }, -- Used to underline "Warning" diagnostics
    DiagnosticUnderlineInfo = { undercurl = true, sp = c.info }, -- Used to underline "Information" diagnostics
    DiagnosticUnderlineHint = { undercurl = true, sp = c.hint }, -- Used to underline "Hint" diagnostics

    -- Health
    healthError = { fg = c.error },
    healthSuccess = { fg = c.green1 },
    healthWarning = { fg = c.warning },

    -- diff (not needed anymore?)
    diffAdded = { bg = c.diff.add, fg = c.git.add },
    diffRemoved = { bg = c.diff.delete, fg = c.git.delete },
    diffChanged = { bg = c.diff.change, fg = c.git.change },
    diffOldFile = { fg = c.blue1, bg = c.diff.delete },
    diffNewFile = { fg = c.blue1, bg = c.diff.add },
    diffFile = { fg = c.blue },
    diffLine = { fg = c.comment },
    diffIndexLine = { fg = c.magenta },
    helpExample = { fg = c.comment },
  },
}

M.treesitter = {
  ['@annotation'] = 'PreProc',
  ['@attribute'] = 'PreProc',
  -- ["@boolean"]                    = "Boolean",
  -- ["@character"]                  = "Character",
  ['@character.printf'] = 'SpecialChar',
  -- ["@character.special"]          = "SpecialChar",
  -- ["@comment"]                    = "Comment",
  -- ["@comment.error"]              = { fg = c.error },
  ['@comment.hint'] = { fg = c.hint },
  ['@comment.info'] = { fg = c.info },
  -- ["@comment.note"]               = { fg = c.hint },
  -- ["@comment.todo"]               = { fg = c.todo },
  -- ["@comment.warning"]            = { fg = c.warning },
  -- ["@constant"]                   = "Constant",
  -- ["@constant.builtin"]           = "Special",
  ['@constant.macro'] = 'Define',
  -- ["@constructor"]                = { fg = c.magenta }, -- For constructor calls and definitions: `= { }` in Lua, and Java constructors.
  ['@diff.delta'] = 'DiffChange',
  ['@diff.minus'] = 'DiffDelete',
  ['@diff.plus'] = 'DiffAdd',
  ['@function'] = 'Function',
  ['@function.builtin'] = 'Special',
  ['@function.call'] = '@function',
  ['@function.macro'] = 'Macro',
  ['@function.method'] = 'Function',
  ['@function.method.call'] = '@function.method',
  ['@keyword'] = { fg = c.purple, bold = true }, -- For keywords that don't fall in previous categories.
  ['@keyword.conditional'] = 'Conditional',
  ['@keyword.coroutine'] = '@keyword',
  ['@keyword.debug'] = 'Debug',
  ['@keyword.directive'] = 'PreProc',
  ['@keyword.directive.define'] = 'Define',
  ['@keyword.exception'] = 'Exception',
  --   ['@keyword.function'] = { fg = c.red },
  ['@keyword.function'] = { fg = c.magenta }, -- For keywords used to define a function.
  ['@keyword.import'] = 'Include',
  ['@keyword.operator'] = '@operator',
  ['@keyword.repeat'] = 'Repeat',
  ['@keyword.return'] = '@keyword',
  ['@keyword.storage'] = 'StorageClass',
  ['@label'] = { fg = c.blue }, -- For labels: `label:` in C and `:label:` in Lua.
  ['@markup'] = '@none',
  ['@markup.emphasis'] = { italic = true },
  ['@markup.environment'] = 'Macro',
  ['@markup.environment.name'] = 'Type',
  ['@markup.heading'] = 'Title',
  ['@markup.italic'] = { italic = true },
  ['@markup.link'] = { fg = c.teal },
  ['@markup.link.label'] = 'SpecialChar',
  ['@markup.link.label.symbol'] = 'Identifier',
  ['@markup.link.url'] = 'Underlined',
  ['@markup.list'] = { fg = c.blue5 }, -- For special punctutation that does not fall in the categories before.
  ['@markup.list.checked'] = { fg = c.green1 }, -- For brackets and parens.
  ['@markup.list.markdown'] = { fg = c.orange, bold = true },
  ['@markup.list.unchecked'] = { fg = c.blue }, -- For brackets and parens.
  ['@markup.math'] = 'Special',
  ['@markup.raw'] = 'String',
  ['@markup.raw.markdown_inline'] = { bg = c.terminal_black, fg = c.blue },
  ['@markup.strikethrough'] = { strikethrough = true },
  ['@markup.strong'] = { bold = true },
  ['@markup.underline'] = { underline = true },
  ['@module'] = 'Include',
  ['@module.builtin'] = { fg = c.red }, -- Variable names that are defined by the languages, like `this` or `self`.
  ['@namespace.builtin'] = '@variable.builtin',
  ['@none'] = {},
  ['@number'] = 'Number',
  ['@number.float'] = 'Float',
  ['@operator'] = { fg = c.blue5 }, -- For any operator: `+`, but also `->` and `*` in C.
  ['@property'] = { fg = c.green1 },
  --   ['@property'] = { fg = c.yellow },
  ['@punctuation.bracket'] = { fg = c.fg_dark }, -- For brackets and parens.
  ['@punctuation.delimiter'] = { fg = c.blue5 }, -- For delimiters ie: `.`
  ['@punctuation.special'] = { fg = c.blue5 }, -- For special symbols (e.g. `{}` in string interpolation)
  ['@punctuation.special.markdown'] = { fg = c.orange }, -- For special symbols (e.g. `{}` in string interpolation)
  ['@string'] = 'String',
  ['@string.documentation'] = { fg = c.yellow },
  ['@string.escape'] = { fg = c.magenta }, -- For escape characters within a string.
  ['@string.regexp'] = { fg = c.blue6 }, -- For regexes.
  ['@tag'] = 'Label',
  ['@tag.attribute'] = '@property',
  ['@tag.delimiter'] = 'Delimiter',
  ['@tag.javascript'] = { fg = c.red },
  ['@type'] = 'Type',
  ['@type.builtin'] = { fg = Blend_bg(c.blue1, 0.8) },
  ['@type.definition'] = 'Typedef',
  ['@type.qualifier'] = '@keyword',
  ['@variable'] = { fg = c.fg }, -- Any variable name that does not have another highlight.
  ['@variable.builtin'] = { fg = c.red }, -- Variable names that are defined by the languages, like `this` or `self`.
  ['@variable.member'] = { fg = c.green1 }, -- For fields.
  --   ['@variable.member'] = { fg = c.blue },
  ['@variable.parameter'] = { fg = c.yellow }, -- For parameters of a function.
  --   ['@variable.parameter'] = { fg = c.magenta },
  ['@variable.parameter.builtin'] = { fg = Blend_fg(c.yellow, 0.8) }, -- For builtin parameters of a function, e.g. "..." or Smali's p[1-99]
  TreesitterContext = { bg = Blend_bg(c.fg_gutter, 0.8) },
}
for i, color in ipairs(c.rainbow) do
  M.treesitter['@markup.heading.' .. i .. '.markdown'] =
    { fg = color, bold = true, bg = Blend_bg(color, 0.1) }
end

M.semantic_tokens = {
  ['@lsp.type.boolean'] = '@boolean',
  ['@lsp.type.builtinType'] = '@type.builtin',
  ['@lsp.type.comment'] = '@comment',
  ['@lsp.type.decorator'] = '@attribute',
  ['@lsp.type.deriveHelper'] = '@attribute',
  ['@lsp.type.enum'] = '@type',
  ['@lsp.type.enumMember'] = '@constant',
  ['@lsp.type.escapeSequence'] = '@string.escape',
  ['@lsp.type.formatSpecifier'] = '@markup.list',
  ['@lsp.type.generic'] = '@variable',
  ['@lsp.type.interface'] = { fg = Blend_fg(c.blue1, 0.7) },
  ['@lsp.type.keyword'] = '@keyword',
  ['@lsp.type.lifetime'] = '@keyword.storage',
  ['@lsp.type.namespace'] = '@module',
  ['@lsp.type.namespace.python'] = '@variable',
  ['@lsp.type.number'] = '@number',
  ['@lsp.type.operator'] = '@operator',
  ['@lsp.type.parameter'] = '@variable.parameter',
  ['@lsp.type.property'] = '@property',
  ['@lsp.type.selfKeyword'] = '@variable.builtin',
  ['@lsp.type.selfTypeKeyword'] = '@variable.builtin',
  ['@lsp.type.string'] = '@string',
  ['@lsp.type.typeAlias'] = '@type.definition',
  ['@lsp.type.unresolvedReference'] = { undercurl = true, sp = c.error },
  ['@lsp.type.variable'] = {}, -- use treesitter styles for regular variables
  ['@lsp.typemod.class.defaultLibrary'] = '@type.builtin',
  ['@lsp.typemod.enum.defaultLibrary'] = '@type.builtin',
  ['@lsp.typemod.enumMember.defaultLibrary'] = '@constant.builtin',
  ['@lsp.typemod.function.defaultLibrary'] = '@function.builtin',
  ['@lsp.typemod.keyword.async'] = '@keyword.coroutine',
  ['@lsp.typemod.keyword.injected'] = '@keyword',
  ['@lsp.typemod.macro.defaultLibrary'] = '@function.builtin',
  ['@lsp.typemod.method.defaultLibrary'] = '@function.builtin',
  ['@lsp.typemod.operator.injected'] = '@operator',
  ['@lsp.typemod.string.injected'] = '@string',
  ['@lsp.typemod.struct.defaultLibrary'] = '@type.builtin',
  ['@lsp.typemod.type.defaultLibrary'] = { fg = Blend_bg(c.blue1, 0.8) },
  ['@lsp.typemod.typeAlias.defaultLibrary'] = { fg = Blend_bg(c.blue1, 0.8) },
  ['@lsp.typemod.variable.callable'] = '@function',
  ['@lsp.typemod.variable.defaultLibrary'] = '@variable.builtin',
  ['@lsp.typemod.variable.injected'] = '@variable',
  ['@lsp.typemod.variable.static'] = '@constant',
}

M.kinds = require('tokyonight.groups.kinds').get()
M.blink = require('tokyonight.groups.blink').get(c) -- needs kinds
M.snacks = require('tokyonight.groups.snacks').get(c, opts)
-- rm = require('tokyonight.groups.render-markdown').get(c)
-- MiniDiffOverAdd     = "DiffAdd",
-- MiniDiffOverChange  = "DiffText",
-- MiniDiffOverContext = "DiffChange",
-- MiniDiffOverDelete  = "DiffDelete",
-- MiniDiffSignAdd     = { fg = c.git.add },
-- MiniDiffSignChange  = { fg = c.git.change },
-- MiniDiffSignDelete  = { fg = c.git.delete },
-- MiniHipatternsFixme = { fg = c.black, bg = c.error, bold = true },
-- MiniHipatternsHack  = { fg = c.black, bg = c.warning, bold = true },
-- MiniHipatternsNote  = { fg = c.black, bg = c.hint, bold = true },
-- MiniHipatternsTodo  = { fg = c.black, bg = c.info, bold = true },
-- WhichKey            = { fg = c.cyan },
-- WhichKeyGroup       = { fg = c.blue },
-- WhichKeyDesc        = { fg = c.magenta },
-- WhichKeySeparator   = { fg = c.comment },
-- WhichKeyNormal      = { bg = c.bg_sidebar },
-- WhichKeyValue       = { fg = c.dark5 },

return M
