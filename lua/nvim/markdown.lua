---@type render.md.UserConfig
vim.g.render_markdown_config = {
  file_types = { 'markdown', 'rmd', 'quarto' },
  latex = { enabled = false },
  bullet = {
    enabled = false,
    right_pad = 1,
  },
  -- checkbox = { enabled = false },
  completions = { lsp = { enabled = false } },
  html = {
    comment = { conceal = false },
    enabled = false,
  },
}

if not Snacks then return end

local render =  require('render-markdown')
Snacks.toggle({
  name = 'Render Markdown',
  get = render.get
  set = render.state
}):map('yom')
