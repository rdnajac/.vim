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
    -- render_modes = { 'n', 'c', 't', 'i' },
    sign = false,
    conceal_delimiters = false,
    language = true,
    position = 'left',
    language_icon = true,
    language_name = false,
    language_info = false,
    width = 'block',
    min_width = 0,
    border = 'thin',
    -- highlight = 'RenderMarkdownCode',
    -- highlight_info = 'RenderMarkdownCodeInfo',
    -- highlight_language = nil,
    -- highlight_border = 'RenderMarkdownCodeBorder',
    -- highlight_fallback = 'RenderMarkdownCodeFallback',
    -- highlight_inline = 'RenderMarkdownCodeInline',
    style = 'normal',
  },
  heading = {
    sign = false, 
    width = 'full',
    position = 'inline',
    -- icons = '',
  },
  html = { comment = { conceal = false } },
}

-- tODO: use m.after
vim.schedule(function()
  Snacks.toggle({
    name = 'Render Markdown',
    get = function()
      return require('render-markdown.state').enabled
    end,
    set = function(enabled)
      require('render-markdown').set(enabled)
    end,
  }):map('<leader>um')
end)

return M
