return {
  ["@annotation"] = "PreProc",
  ["@attribute"] = "PreProc",
  ["@boolean"] = "Boolean",
  ["@character"] = "Character",
  ["@character.printf"] = "SpecialChar",
  ["@character.special"] = "SpecialChar",
  ["@comment"] = "Comment",
  ["@comment.error"] = {
    fg = "#db4b4b"
  },
  ["@comment.hint"] = {
    fg = "#1abc9c"
  },
  ["@comment.info"] = {
    fg = "#0db9d7"
  },
  ["@comment.note"] = {
    fg = "#1abc9c"
  },
  ["@comment.todo"] = {
    fg = "#7aa2f7"
  },
  ["@comment.warning"] = {
    fg = "#e0af68"
  },
  ["@constant"] = "Constant",
  ["@constant.builtin"] = "Special",
  ["@constant.macro"] = "Define",
  ["@constructor"] = {
    fg = "#bb9af7"
  },
  ["@constructor.tsx"] = {
    fg = "#2ac3de"
  },
  ["@diff.delta"] = "DiffChange",
  ["@diff.minus"] = "DiffDelete",
  ["@diff.plus"] = "DiffAdd",
  ["@function"] = "Function",
  ["@function.builtin"] = "Special",
  ["@function.call"] = "@function",
  ["@function.macro"] = "Macro",
  ["@function.method"] = "Function",
  ["@function.method.call"] = "@function.method",
  ["@keyword"] = {
    bold = true,
    fg = "#9d7cd8",
    italic = false
  },
  ["@keyword.conditional"] = "Conditional",
  ["@keyword.coroutine"] = "@keyword",
  ["@keyword.debug"] = "Debug",
  ["@keyword.directive"] = "PreProc",
  ["@keyword.directive.define"] = "Define",
  ["@keyword.exception"] = "Exception",
  ["@keyword.function"] = {
    fg = "#bb9af7"
  },
  ["@keyword.import"] = "Include",
  ["@keyword.operator"] = "@operator",
  ["@keyword.repeat"] = "Repeat",
  ["@keyword.return"] = "@keyword",
  ["@keyword.storage"] = "StorageClass",
  ["@label"] = {
    fg = "#14afff"
  },
  ["@lsp.type.boolean"] = "@boolean",
  ["@lsp.type.builtinType"] = "@type.builtin",
  ["@lsp.type.comment"] = "@comment",
  ["@lsp.type.decorator"] = "@attribute",
  ["@lsp.type.deriveHelper"] = "@attribute",
  ["@lsp.type.enum"] = "@type",
  ["@lsp.type.enumMember"] = "@constant",
  ["@lsp.type.escapeSequence"] = "@string.escape",
  ["@lsp.type.formatSpecifier"] = "@markup.list",
  ["@lsp.type.generic"] = "@variable",
  ["@lsp.type.interface"] = {
    fg = "#57c5e5"
  },
  ["@lsp.type.keyword"] = "@keyword",
  ["@lsp.type.lifetime"] = "@keyword.storage",
  ["@lsp.type.namespace"] = "@module",
  ["@lsp.type.namespace.python"] = "@variable",
  ["@lsp.type.number"] = "@number",
  ["@lsp.type.operator"] = "@operator",
  ["@lsp.type.parameter"] = "@variable.parameter",
  ["@lsp.type.property"] = "@property",
  ["@lsp.type.selfKeyword"] = "@variable.builtin",
  ["@lsp.type.selfTypeKeyword"] = "@variable.builtin",
  ["@lsp.type.string"] = "@string",
  ["@lsp.type.typeAlias"] = "@type.definition",
  ["@lsp.type.unresolvedReference"] = {
    sp = "#db4b4b",
    undercurl = true
  },
  ["@lsp.type.variable"] = {},
  ["@lsp.typemod.class.defaultLibrary"] = "@type.builtin",
  ["@lsp.typemod.enum.defaultLibrary"] = "@type.builtin",
  ["@lsp.typemod.enumMember.defaultLibrary"] = "@constant.builtin",
  ["@lsp.typemod.function.defaultLibrary"] = "@function.builtin",
  ["@lsp.typemod.keyword.async"] = "@keyword.coroutine",
  ["@lsp.typemod.keyword.injected"] = "@keyword",
  ["@lsp.typemod.macro.defaultLibrary"] = "@function.builtin",
  ["@lsp.typemod.method.defaultLibrary"] = "@function.builtin",
  ["@lsp.typemod.operator.injected"] = "@operator",
  ["@lsp.typemod.string.injected"] = "@string",
  ["@lsp.typemod.struct.defaultLibrary"] = "@type.builtin",
  ["@lsp.typemod.type.defaultLibrary"] = {
    fg = "#27a1b9"
  },
  ["@lsp.typemod.typeAlias.defaultLibrary"] = {
    fg = "#27a1b9"
  },
  ["@lsp.typemod.variable.callable"] = "@function",
  ["@lsp.typemod.variable.defaultLibrary"] = "@variable.builtin",
  ["@lsp.typemod.variable.injected"] = "@variable",
  ["@lsp.typemod.variable.static"] = "@constant",
  ["@markup"] = "@none",
  ["@markup.emphasis"] = {
    italic = true
  },
  ["@markup.environment"] = "Macro",
  ["@markup.environment.name"] = "Type",
  ["@markup.heading"] = "Title",
  ["@markup.heading.1.markdown"] = {
    bg = "#24293b",
    bold = true,
    fg = "#7aa2f7"
  },
  ["@markup.heading.2.markdown"] = {
    bg = "#2e2a2d",
    bold = true,
    fg = "#e0af68"
  },
  ["@markup.heading.3.markdown"] = {
    bg = "#272d2d",
    bold = true,
    fg = "#9ece6a"
  },
  ["@markup.heading.4.markdown"] = {
    bg = "#1a2b32",
    bold = true,
    fg = "#1abc9c"
  },
  ["@markup.heading.5.markdown"] = {
    bg = "#2a283b",
    bold = true,
    fg = "#bb9af7"
  },
  ["@markup.heading.6.markdown"] = {
    bg = "#272538",
    bold = true,
    fg = "#9d7cd8"
  },
  ["@markup.heading.7.markdown"] = {
    bg = "#31282c",
    bold = true,
    fg = "#ff9e64"
  },
  ["@markup.heading.8.markdown"] = {
    bg = "#302430",
    bold = true,
    fg = "#f7768e"
  },
  ["@markup.italic"] = {
    italic = true
  },
  ["@markup.link"] = {
    fg = "#1abc9c"
  },
  ["@markup.link.label"] = "SpecialChar",
  ["@markup.link.label.symbol"] = "Identifier",
  ["@markup.link.url"] = "Underlined",
  ["@markup.list"] = {
    fg = "#89ddff"
  },
  ["@markup.list.checked"] = {
    fg = "#73daca"
  },
  ["@markup.list.markdown"] = {
    bold = true,
    fg = "#ff9e64"
  },
  ["@markup.list.unchecked"] = {
    fg = "#14afff"
  },
  ["@markup.math"] = "Special",
  ["@markup.raw"] = "String",
  ["@markup.raw.markdown_inline"] = {
    bg = "#414868",
    fg = "#14afff"
  },
  ["@markup.strikethrough"] = {
    strikethrough = true
  },
  ["@markup.strong"] = {
    bold = true
  },
  ["@markup.underline"] = {
    underline = true
  },
  ["@module"] = "Include",
  ["@module.builtin"] = {
    fg = "#f7768e"
  },
  ["@namespace.builtin"] = "@variable.builtin",
  ["@none"] = {},
  ["@number"] = "Number",
  ["@number.float"] = "Float",
  ["@operator"] = {
    fg = "#89ddff"
  },
  ["@property"] = {
    fg = "#73daca"
  },
  ["@punctuation.bracket"] = {
    fg = "#a9b1d6"
  },
  ["@punctuation.delimiter"] = {
    fg = "#89ddff"
  },
  ["@punctuation.special"] = {
    fg = "#89ddff"
  },
  ["@punctuation.special.markdown"] = {
    fg = "#ff9e64"
  },
  ["@string"] = "String",
  ["@string.documentation"] = {
    fg = "#e0af68"
  },
  ["@string.escape"] = {
    fg = "#bb9af7"
  },
  ["@string.regexp"] = {
    fg = "#b4f9f8"
  },
  ["@tag"] = "Label",
  ["@tag.attribute"] = "@property",
  ["@tag.delimiter"] = "Delimiter",
  ["@tag.delimiter.tsx"] = {
    fg = "#1683be"
  },
  ["@tag.javascript"] = {
    fg = "#f7768e"
  },
  ["@tag.tsx"] = {
    fg = "#f7768e"
  },
  ["@type"] = "Type",
  ["@type.builtin"] = {
    fg = "#27a1b9"
  },
  ["@type.definition"] = "Typedef",
  ["@type.qualifier"] = "@keyword",
  ["@variable"] = {
    fg = "#c0caf5",
    italic = false
  },
  ["@variable.builtin"] = {
    fg = "#f7768e"
  },
  ["@variable.member"] = {
    fg = "#73daca"
  },
  ["@variable.parameter"] = {
    fg = "#e0af68"
  },
  ["@variable.parameter.builtin"] = {
    fg = "#dab484"
  },
  ALEErrorSign = {
    fg = "#db4b4b"
  },
  ALEWarningSign = {
    fg = "#e0af68"
  },
  BlinkCmpDoc = {
    bg = "NONE",
    fg = "#c0caf5"
  },
  BlinkCmpDocBorder = {
    bg = "NONE",
    fg = "#27a1b9"
  },
  BlinkCmpGhostText = {
    fg = "#414868"
  },
  BlinkCmpKindArray = "LspKindArray",
  BlinkCmpKindBoolean = "LspKindBoolean",
  BlinkCmpKindClass = "LspKindClass",
  BlinkCmpKindCodeium = {
    bg = "NONE",
    fg = "#1abc9c"
  },
  BlinkCmpKindColor = "LspKindColor",
  BlinkCmpKindConstant = "LspKindConstant",
  BlinkCmpKindConstructor = "LspKindConstructor",
  BlinkCmpKindCopilot = {
    bg = "NONE",
    fg = "#1abc9c"
  },
  BlinkCmpKindDefault = {
    bg = "NONE",
    fg = "#a9b1d6"
  },
  BlinkCmpKindEnum = "LspKindEnum",
  BlinkCmpKindEnumMember = "LspKindEnumMember",
  BlinkCmpKindEvent = "LspKindEvent",
  BlinkCmpKindField = "LspKindField",
  BlinkCmpKindFile = "LspKindFile",
  BlinkCmpKindFolder = "LspKindFolder",
  BlinkCmpKindFunction = "LspKindFunction",
  BlinkCmpKindInterface = "LspKindInterface",
  BlinkCmpKindKey = "LspKindKey",
  BlinkCmpKindKeyword = "LspKindKeyword",
  BlinkCmpKindMethod = "LspKindMethod",
  BlinkCmpKindModule = "LspKindModule",
  BlinkCmpKindNamespace = "LspKindNamespace",
  BlinkCmpKindNull = "LspKindNull",
  BlinkCmpKindNumber = "LspKindNumber",
  BlinkCmpKindObject = "LspKindObject",
  BlinkCmpKindOperator = "LspKindOperator",
  BlinkCmpKindPackage = "LspKindPackage",
  BlinkCmpKindProperty = "LspKindProperty",
  BlinkCmpKindReference = "LspKindReference",
  BlinkCmpKindSnippet = "LspKindSnippet",
  BlinkCmpKindString = "LspKindString",
  BlinkCmpKindStruct = "LspKindStruct",
  BlinkCmpKindSupermaven = {
    bg = "NONE",
    fg = "#1abc9c"
  },
  BlinkCmpKindTabNine = {
    bg = "NONE",
    fg = "#1abc9c"
  },
  BlinkCmpKindText = "LspKindText",
  BlinkCmpKindTypeParameter = "LspKindTypeParameter",
  BlinkCmpKindUnit = "LspKindUnit",
  BlinkCmpKindValue = "LspKindValue",
  BlinkCmpKindVariable = "LspKindVariable",
  BlinkCmpLabel = {
    bg = "NONE",
    fg = "#c0caf5"
  },
  BlinkCmpLabelDeprecated = {
    bg = "NONE",
    fg = "#3b4261",
    strikethrough = true
  },
  BlinkCmpLabelMatch = {
    bg = "NONE",
    fg = "#2ac3de"
  },
  BlinkCmpMenu = {
    bg = "NONE",
    fg = "#c0caf5"
  },
  BlinkCmpMenuBorder = {
    bg = "NONE",
    fg = "#27a1b9"
  },
  BlinkCmpSignatureHelp = {
    bg = "NONE",
    fg = "#c0caf5"
  },
  BlinkCmpSignatureHelpBorder = {
    bg = "NONE",
    fg = "#27a1b9"
  },
  Bold = {
    bold = true,
    fg = "#c0caf5"
  },
  Character = {
    fg = "#39ff14"
  },
  ColorColumn = {
    bg = "#000000"
  },
  Comment = {
    fg = "#565f89",
    italic = true
  },
  ComplHint = {
    fg = "#414868"
  },
  Conceal = {
    fg = "#737aa2"
  },
  Constant = {
    fg = "#ff9e64"
  },
  CurSearch = "IncSearch",
  Cursor = {
    bg = "#c0caf5",
    fg = "#1a1b26"
  },
  CursorColumn = {
    bg = "#292e42"
  },
  CursorIM = {
    bg = "#c0caf5",
    fg = "#1a1b26"
  },
  CursorLine = {
    bg = "#292e42"
  },
  CursorLineNr = {
    bold = true,
    fg = "#ff9e64"
  },
  Debug = {
    fg = "#ff9e64"
  },
  Delimiter = "Special",
  DiagnosticError = {
    fg = "#db4b4b"
  },
  DiagnosticHint = {
    fg = "#1abc9c"
  },
  DiagnosticInfo = {
    fg = "#0db9d7"
  },
  DiagnosticUnderlineError = {
    sp = "#db4b4b",
    undercurl = true
  },
  DiagnosticUnderlineHint = {
    sp = "#1abc9c",
    undercurl = true
  },
  DiagnosticUnderlineInfo = {
    sp = "#0db9d7",
    undercurl = true
  },
  DiagnosticUnderlineWarn = {
    sp = "#e0af68",
    undercurl = true
  },
  DiagnosticUnnecessary = {
    fg = "#414868"
  },
  DiagnosticVirtualTextError = {
    bg = "#2d202a",
    fg = "#db4b4b"
  },
  DiagnosticVirtualTextHint = {
    bg = "#1a2b32",
    fg = "#1abc9c"
  },
  DiagnosticVirtualTextInfo = {
    bg = "#192b38",
    fg = "#0db9d7"
  },
  DiagnosticVirtualTextWarn = {
    bg = "#2e2a2d",
    fg = "#e0af68"
  },
  DiagnosticWarn = {
    fg = "#e0af68"
  },
  DiffAdd = {
    bg = "#243e4a"
  },
  DiffChange = {
    bg = "#1f2231"
  },
  DiffDelete = {
    bg = "#4a272f"
  },
  DiffText = {
    bg = "#394b70"
  },
  Directory = {
    fg = "#14afff"
  },
  EndOfBuffer = {
    fg = "#1a1b26"
  },
  Error = {
    fg = "#db4b4b"
  },
  ErrorMsg = {
    fg = "#db4b4b"
  },
  FloatBorder = {
    bg = "NONE",
    fg = "#27a1b9"
  },
  FloatTitle = {
    bg = "NONE",
    fg = "#27a1b9"
  },
  FoldColumn = {
    bg = "NONE",
    fg = "#565f89"
  },
  Folded = {
    bg = "#3b4261",
    fg = "#14afff"
  },
  Foo = {
    bg = "#ff007c",
    fg = "#c0caf5"
  },
  Function = {
    fg = "#14afff"
  },
  Identifier = {
    fg = "#bb9af7",
    italic = false
  },
  IncSearch = {
    bg = "#ff9e64",
    fg = "#000000"
  },
  Italic = {
    fg = "#c0caf5",
    italic = true
  },
  Keyword = {
    bold = true,
    fg = "#7dcfff",
    italic = false
  },
  LineNr = {
    fg = "#3b4261"
  },
  LineNrAbove = {
    fg = "#3b4261"
  },
  LineNrBelow = {
    fg = "#3b4261"
  },
  LspCodeLens = {
    fg = "#565f89"
  },
  LspInfoBorder = {
    bg = "NONE",
    fg = "#27a1b9"
  },
  LspInlayHint = {
    bg = "#1d202d",
    fg = "#545c7e"
  },
  LspKindArray = "@punctuation.bracket",
  LspKindBoolean = "@boolean",
  LspKindClass = "@type",
  LspKindColor = "Special",
  LspKindConstant = "@constant",
  LspKindConstructor = "@constructor",
  LspKindEnum = "@lsp.type.enum",
  LspKindEnumMember = "@lsp.type.enumMember",
  LspKindEvent = "Special",
  LspKindField = "@variable.member",
  LspKindFile = "Normal",
  LspKindFolder = "Directory",
  LspKindFunction = "@function",
  LspKindInterface = "@lsp.type.interface",
  LspKindKey = "@variable.member",
  LspKindKeyword = "@lsp.type.keyword",
  LspKindMethod = "@function.method",
  LspKindModule = "@module",
  LspKindNamespace = "@module",
  LspKindNull = "@constant.builtin",
  LspKindNumber = "@number",
  LspKindObject = "@constant",
  LspKindOperator = "@operator",
  LspKindPackage = "@module",
  LspKindProperty = "@property",
  LspKindReference = "@markup.link",
  LspKindSnippet = "Conceal",
  LspKindString = "@string",
  LspKindStruct = "@lsp.type.struct",
  LspKindText = "@markup",
  LspKindTypeParameter = "@lsp.type.typeParameter",
  LspKindUnit = "@lsp.type.struct",
  LspKindValue = "@string",
  LspKindVariable = "@variable",
  LspReferenceRead = {
    bg = "#3b4261"
  },
  LspReferenceText = {
    bg = "#3b4261"
  },
  LspReferenceWrite = {
    bg = "#3b4261"
  },
  LspSignatureActiveParameter = {
    bg = "#20253a",
    bold = true
  },
  MatchParen = {
    bold = true,
    fg = "#ff9e64"
  },
  MiniDiffOverAdd = "DiffAdd",
  MiniDiffOverChange = "DiffText",
  MiniDiffOverContext = "DiffChange",
  MiniDiffOverDelete = "DiffDelete",
  MiniDiffSignAdd = {
    fg = "#449dab"
  },
  MiniDiffSignChange = {
    fg = "#6183bb"
  },
  MiniDiffSignDelete = {
    fg = "#914c54"
  },
  MiniFilesBorder = "FloatBorder",
  MiniFilesBorderModified = "DiagnosticFloatingWarn",
  MiniFilesCursorLine = "CursorLine",
  MiniFilesDirectory = "Directory",
  MiniFilesFile = {
    fg = "#c0caf5"
  },
  MiniFilesNormal = "NormalFloat",
  MiniFilesTitle = "FloatTitle",
  MiniFilesTitleFocused = {
    bg = "NONE",
    bold = true,
    fg = "#27a1b9"
  },
  MiniHipatternsFixme = {
    bg = "#db4b4b",
    bold = true,
    fg = "#000000"
  },
  MiniHipatternsHack = {
    bg = "#e0af68",
    bold = true,
    fg = "#000000"
  },
  MiniHipatternsNote = {
    bg = "#1abc9c",
    bold = true,
    fg = "#000000"
  },
  MiniHipatternsTodo = {
    bg = "#0db9d7",
    bold = true,
    fg = "#000000"
  },
  MiniIconsAzure = {
    fg = "#0db9d7"
  },
  MiniIconsBlue = {
    fg = "#14afff"
  },
  MiniIconsCyan = {
    fg = "#1abc9c"
  },
  MiniIconsGreen = {
    fg = "#39ff14"
  },
  MiniIconsGrey = {
    fg = "#c0caf5"
  },
  MiniIconsOrange = {
    fg = "#ff9e64"
  },
  MiniIconsPurple = {
    fg = "#9d7cd8"
  },
  MiniIconsRed = {
    fg = "#f7768e"
  },
  MiniIconsYellow = {
    fg = "#e0af68"
  },
  MiniSurround = {
    bg = "#ff9e64",
    fg = "#000000"
  },
  ModeMsg = {
    bold = true,
    fg = "#a9b1d6"
  },
  MoreMsg = {
    fg = "#14afff"
  },
  MsgArea = {
    fg = "#a9b1d6"
  },
  NonText = {
    fg = "#545c7e"
  },
  Normal = {
    bg = "NONE",
    fg = "#c0caf5"
  },
  NormalFloat = {
    bg = "NONE",
    fg = "#c0caf5"
  },
  NormalNC = {
    bg = "NONE",
    fg = "#c0caf5"
  },
  NormalSB = {
    bg = "NONE",
    fg = "#a9b1d6"
  },
  Number = {
    fg = "#14afff"
  },
  Operator = {
    fg = "#89ddff"
  },
  Pmenu = {
    bg = "#16161e",
    fg = "#c0caf5"
  },
  PmenuMatch = {
    bg = "#16161e",
    fg = "#2ac3de"
  },
  PmenuMatchSel = {
    bg = "#343a55",
    fg = "#2ac3de"
  },
  PmenuSbar = {
    bg = "#1f1f29"
  },
  PmenuSel = {
    bg = "#343a55"
  },
  PmenuThumb = {
    bg = "#3b4261"
  },
  PreProc = {
    fg = "#7dcfff"
  },
  Question = {
    fg = "#14afff"
  },
  QuickFixLine = {
    bg = "#283457",
    bold = true
  },
  RenderMarkdownBullet = {
    fg = "#ff9e64"
  },
  RenderMarkdownCode = {
    bg = "#16161e"
  },
  RenderMarkdownCodeInline = "@markup.raw.markdown_inline",
  RenderMarkdownDash = {
    fg = "#ff9e64"
  },
  RenderMarkdownH1Bg = {
    bg = "#24293b"
  },
  RenderMarkdownH1Fg = {
    bold = true,
    fg = "#7aa2f7"
  },
  RenderMarkdownH2Bg = {
    bg = "#2e2a2d"
  },
  RenderMarkdownH2Fg = {
    bold = true,
    fg = "#e0af68"
  },
  RenderMarkdownH3Bg = {
    bg = "#272d2d"
  },
  RenderMarkdownH3Fg = {
    bold = true,
    fg = "#9ece6a"
  },
  RenderMarkdownH4Bg = {
    bg = "#1a2b32"
  },
  RenderMarkdownH4Fg = {
    bold = true,
    fg = "#1abc9c"
  },
  RenderMarkdownH5Bg = {
    bg = "#2a283b"
  },
  RenderMarkdownH5Fg = {
    bold = true,
    fg = "#bb9af7"
  },
  RenderMarkdownH6Bg = {
    bg = "#272538"
  },
  RenderMarkdownH6Fg = {
    bold = true,
    fg = "#9d7cd8"
  },
  RenderMarkdownH7Bg = {
    bg = "#31282c"
  },
  RenderMarkdownH7Fg = {
    bold = true,
    fg = "#ff9e64"
  },
  RenderMarkdownH8Bg = {
    bg = "#302430"
  },
  RenderMarkdownH8Fg = {
    bold = true,
    fg = "#f7768e"
  },
  RenderMarkdownTableHead = {
    fg = "#f7768e"
  },
  RenderMarkdownTableRow = {
    fg = "#ff9e64"
  },
  Search = {
    bg = "#3d59a1",
    fg = "#c0caf5"
  },
  SidekickDiffAdd = "DiffAdd",
  SidekickDiffContext = "DiffChange",
  SidekickDiffDelete = "DiffDelete",
  SidekickSignAdd = {
    fg = "#449dab"
  },
  SidekickSignChange = {
    fg = "#6183bb"
  },
  SidekickSignDelete = {
    fg = "#914c54"
  },
  SignColumn = {
    bg = "NONE",
    fg = "#3b4261"
  },
  SignColumnSB = {
    bg = "NONE",
    fg = "#3b4261"
  },
  SnacksDashboardDesc = {
    fg = "#7dcfff"
  },
  SnacksDashboardDir = {
    fg = "#545c7e"
  },
  SnacksDashboardFooter = {
    fg = "#2ac3de"
  },
  SnacksDashboardHeader = {
    fg = "#14afff"
  },
  SnacksDashboardIcon = {
    fg = "#2ac3de"
  },
  SnacksDashboardKey = {
    fg = "#ff9e64"
  },
  SnacksDashboardSpecial = {
    fg = "#9d7cd8"
  },
  SnacksFooterDesc = "SnacksProfilerBadgeInfo",
  SnacksFooterKey = "SnacksProfilerIconInfo",
  SnacksGhDiffHeader = {
    bg = "#1c2c38",
    fg = "#2ac3de"
  },
  SnacksGhLabel = {
    bold = true,
    fg = "#2ac3de"
  },
  SnacksIndent = {
    fg = "#3b4261",
    nocombine = true
  },
  SnacksIndent1 = {
    fg = "#7aa2f7",
    nocombine = true
  },
  SnacksIndent2 = {
    fg = "#e0af68",
    nocombine = true
  },
  SnacksIndent3 = {
    fg = "#9ece6a",
    nocombine = true
  },
  SnacksIndent4 = {
    fg = "#1abc9c",
    nocombine = true
  },
  SnacksIndent5 = {
    fg = "#bb9af7",
    nocombine = true
  },
  SnacksIndent6 = {
    fg = "#9d7cd8",
    nocombine = true
  },
  SnacksIndent7 = {
    fg = "#ff9e64",
    nocombine = true
  },
  SnacksIndent8 = {
    fg = "#f7768e",
    nocombine = true
  },
  SnacksIndentScope = {
    fg = "#2ac3de",
    nocombine = true
  },
  SnacksInputBorder = {
    fg = "#e0af68"
  },
  SnacksInputIcon = {
    fg = "#2ac3de"
  },
  SnacksInputTitle = {
    fg = "#e0af68"
  },
  SnacksNotifierBorderDebug = {
    bg = "NONE",
    fg = "#32364e"
  },
  SnacksNotifierBorderError = {
    bg = "NONE",
    fg = "#672e35"
  },
  SnacksNotifierBorderInfo = {
    bg = "NONE",
    fg = "#155a6d"
  },
  SnacksNotifierBorderTrace = {
    bg = "NONE",
    fg = "#4e426d"
  },
  SnacksNotifierBorderWarn = {
    bg = "NONE",
    fg = "#695640"
  },
  SnacksNotifierDebug = {
    bg = "NONE",
    fg = "#c0caf5"
  },
  SnacksNotifierError = {
    bg = "NONE",
    fg = "#c0caf5"
  },
  SnacksNotifierIconDebug = {
    fg = "#565f89"
  },
  SnacksNotifierIconError = {
    fg = "#db4b4b"
  },
  SnacksNotifierIconInfo = {
    fg = "#0db9d7"
  },
  SnacksNotifierIconTrace = {
    fg = "#9d7cd8"
  },
  SnacksNotifierIconWarn = {
    fg = "#e0af68"
  },
  SnacksNotifierInfo = {
    bg = "NONE",
    fg = "#c0caf5"
  },
  SnacksNotifierTitleDebug = {
    fg = "#565f89"
  },
  SnacksNotifierTitleError = {
    fg = "#db4b4b"
  },
  SnacksNotifierTitleInfo = {
    fg = "#0db9d7"
  },
  SnacksNotifierTitleTrace = {
    fg = "#9d7cd8"
  },
  SnacksNotifierTitleWarn = {
    fg = "#e0af68"
  },
  SnacksNotifierTrace = {
    bg = "NONE",
    fg = "#c0caf5"
  },
  SnacksNotifierWarn = {
    bg = "NONE",
    fg = "#c0caf5"
  },
  SnacksPickerBoxTitle = {
    bg = "NONE",
    fg = "#ff9e64"
  },
  SnacksPickerInputBorder = {
    bg = "NONE",
    fg = "#ff9e64"
  },
  SnacksPickerInputTitle = {
    bg = "NONE",
    fg = "#ff9e64"
  },
  SnacksPickerPickWin = {
    bg = "#3d59a1",
    bold = true,
    fg = "#c0caf5"
  },
  SnacksPickerPickWinCurrent = {
    bg = "#ff007c",
    bold = true,
    fg = "#c0caf5"
  },
  SnacksPickerSelected = {
    fg = "#ff007c"
  },
  SnacksPickerToggle = "SnacksProfilerBadgeInfo",
  SnacksProfilerBadgeInfo = {
    bg = "#1c2c38",
    fg = "#2ac3de"
  },
  SnacksProfilerBadgeTrace = {
    bg = "#1d202d",
    fg = "#545c7e"
  },
  SnacksProfilerIconInfo = {
    bg = "#1f4d5d",
    fg = "#2ac3de"
  },
  SnacksProfilerIconTrace = {
    bg = "#23293c",
    fg = "#545c7e"
  },
  SnacksZenIcon = {
    fg = "#9d7cd8"
  },
  Special = {
    bold = true,
    fg = "#f7768e"
  },
  SpecialKey = {
    fg = "#545c7e"
  },
  SpellBad = {
    bg = "#f7768e"
  },
  SpellCap = {
    sp = "#e0af68",
    undercurl = true
  },
  SpellLocal = {
    sp = "#0db9d7",
    undercurl = true
  },
  SpellRare = {
    sp = "#1abc9c",
    undercurl = true
  },
  Statement = {
    fg = "#f7768e"
  },
  StatusLine = {
    bg = "#16161e",
    fg = "#a9b1d6"
  },
  StatusLineNC = {
    bg = "#16161e",
    fg = "#3b4261"
  },
  String = {
    fg = "#39ff14"
  },
  Substitute = {
    bg = "#f7768e",
    fg = "#000000"
  },
  TabLine = {
    bg = "#16161e",
    fg = "#3b4261"
  },
  TabLineFill = {
    bg = "NONE"
  },
  TabLineSel = {
    bg = "#14afff",
    fg = "#000000"
  },
  Title = {
    bold = true,
    fg = "#14afff"
  },
  Todo = {
    bg = "#e0af68",
    fg = "#1a1b26"
  },
  TreesitterContext = {
    bg = "#343a55"
  },
  Type = {
    fg = "#2ac3de"
  },
  Underlined = {
    underline = true
  },
  VertSplit = {
    fg = "#15161e"
  },
  Visual = {
    bg = "#283457"
  },
  VisualNOS = {
    bg = "#283457"
  },
  WarningMsg = {
    fg = "#e0af68"
  },
  WhichKey = {
    fg = "#7dcfff"
  },
  WhichKeyDesc = {
    fg = "#bb9af7"
  },
  WhichKeyGroup = {
    fg = "#14afff"
  },
  WhichKeyNormal = {
    bg = "NONE"
  },
  WhichKeySeparator = {
    fg = "#565f89"
  },
  WhichKeyValue = {
    fg = "#737aa2"
  },
  Whitespace = {
    fg = "#3b4261"
  },
  WildMenu = {
    bg = "#283457"
  },
  WinBar = "StatusLine",
  WinBarNC = "StatusLineNC",
  WinSeparator = {
    bold = true,
    fg = "#15161e"
  },
  debugBreakpoint = {
    bg = "#192b38",
    fg = "#0db9d7"
  },
  debugPC = {
    bg = "NONE"
  },
  diffAdded = {
    bg = "#243e4a",
    fg = "#449dab"
  },
  diffChanged = {
    bg = "#1f2231",
    fg = "#6183bb"
  },
  diffFile = {
    fg = "#14afff"
  },
  diffIndexLine = {
    fg = "#bb9af7"
  },
  diffLine = {
    fg = "#565f89"
  },
  diffNewFile = {
    bg = "#243e4a",
    fg = "#2ac3de"
  },
  diffOldFile = {
    bg = "#4a272f",
    fg = "#2ac3de"
  },
  diffRemoved = {
    bg = "#4a272f",
    fg = "#914c54"
  },
  dosIniLabel = "@property",
  healthError = {
    fg = "#db4b4b"
  },
  healthSuccess = {
    fg = "#73daca"
  },
  healthWarning = {
    fg = "#e0af68"
  },
  helpCommand = {
    bg = "#414868",
    fg = "#14afff"
  },
  helpExample = {
    fg = "#565f89"
  },
  htmlH1 = {
    bold = true,
    fg = "#bb9af7"
  },
  htmlH2 = {
    bold = true,
    fg = "#14afff"
  },
  lCursor = {
    bg = "#c0caf5",
    fg = "#1a1b26"
  },
  qfFileName = {
    fg = "#14afff"
  },
  qfLineNr = {
    fg = "#737aa2"
  }
}