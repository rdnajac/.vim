local render = require('render-markdown')
render.setup({
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
})

-- TODO: colorscheme links
-- local ret = {
--   RenderMarkdownBullet    = {fg = c.orange}, -- horizontal rule
--   RenderMarkdownCode      = { bg = c.bg_dark },
--   RenderMarkdownDash      = {fg = c.orange}, -- horizontal rule
--   RenderMarkdownTableHead = { fg = c.red},
--   RenderMarkdownTableRow  = { fg = c.orange},
--   RenderMarkdownCodeInline = "@markup.raw.markdown_inline"
-- }
-- for i, color in ipairs(c.rainbow) do
--   ret["RenderMarkdownH" .. i .. "Bg"] = { bg = Util.blend_bg(color, 0.1) }
--   ret["RenderMarkdownH" .. i .. "Fg"] = { fg = color, bold = true }
-- end

-- vim.schedule(function() Snacks.toggle({ name = 'Render Markdown', get = render.get, set = render.state }):map('yom') end)
