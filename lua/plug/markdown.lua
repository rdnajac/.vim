local M = { 'MeanderingProgrammer/render-markdown.nvim' }

M.event = 'BufWinEnter'
M.ft = { 'markdown', 'rmd', 'quarto', 'codecompanion' }

---@type render.md.UserConfig
M.opts = {
  file_types = M.ft,
  completions = { blink = { enabled = false } },
  bullet = { right_pad = 1 },
  -- checkbox = { enabled = false },
  code = {
    enabled = true,
    render_modes = false,
    sign = false,
    conceal_delimiters = false,
    language = true,
    -- Determines where language icon is rendered.
    -- | right | right side of code block |
    -- | left  | left side of code block  |
    position = 'left',
    -- Whether to include the language icon above code blocks.
    language_icon = true,
    -- Whether to include the language name above code blocks.
    language_name = true,
    -- Whether to include the language info above code blocks.
    language_info = false,
    -- Width of the code block background.
    -- | block | width of the code block  |
    -- | full  | full width of the window |
    width = 'full',
    -- Minimum width to use for code blocks when width is 'block'.
    min_width = 0,
    -- Determines how the top / bottom of code block are rendered.
    -- | none  | do not render a border                               |
    -- | thick | use the same highlight as the code body              |
    -- | thin  | when lines are empty overlay the above & below icons |
    -- | hide  | conceal lines unless language name or icon is added  |
    border = 'hide',
    -- Highlight for code blocks.
    highlight = 'RenderMarkdownCode',
    -- Highlight for code info section, after the language.
    highlight_info = 'RenderMarkdownCodeInfo',
    -- Highlight for language, overrides icon provider value.
    highlight_language = nil,
    -- Highlight for border, use false to add no highlight.
    highlight_border = 'RenderMarkdownCodeBorder',
    -- Highlight for language, used if icon provider does not have a value.
    highlight_fallback = 'RenderMarkdownCodeFallback',
    -- Highlight for inline code.
    highlight_inline = 'RenderMarkdownCodeInline',
    -- Determines how code blocks & inline code are rendered.
    -- | none     | { enabled = false }                           |
    -- | normal   | { language = false }                          |
    -- | language | { disable_background = true, inline = false } |
    -- | full     | uses all default values                       |
    style = 'normal',
  },
  heading = {
    -- sign = false,
    icons = {},
    width = 'block',
    right_pad = 1,
    position = 'inline',
  },
  html = { comment = { conceal = false } },
}

M.config = function()
  require('render-markdown').setup(M.opts)

  Snacks.toggle({
    name = 'Render Markdown',
    get = function()
      return require('render-markdown.state').enabled
    end,
    set = function(enabled)
      require('render-markdown').set(enabled)
    end,
  }):map('<leader>um')
end

return M
