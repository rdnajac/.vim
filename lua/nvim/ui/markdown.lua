---@type render.md.UserConfig
vim.g.render_markdown_config = {
  file_types = { 'markdown', 'rmd', 'quarto' },
  latex = { enabled = false },
  bullet = { right_pad = 1 },
  -- checkbox = { enabled = false },
  completions = { lsp = { enabled = true } },
  code = {
    -- inline_left = ' ',
    -- inline_right = ' ',
    -- inline_padding= 1,
    ---@diagnostic disable-next-line: assign-type-mismatch
    -- highlight = false,
    -- highlight_border = 'Chromatophore',
    --   -- highlight_inline = 'Chromatophore',
    --   sign = false,
    --   conceal_delimiters = false,
    position = 'left',
    --   language_info = false,
    --   width = 'block',
    --   min_width = 0,
    border = 'thin',
    style = 'normal',
  },
  heading = {
    sign = false,
    width = 'full',
    position = 'overlay',
    -- left_pad = { 0, 1, 2, 3, 4, 5 },
    -- icons = '',
  },
  html = {
    comment = { conceal = false },
    enabled = false,
  },
}

vim.schedule(function()
  Snacks.toggle
    .new({
      name = 'Render Markdown',
      get = function() return require('render-markdown.state').enabled end,
      set = function(state) require('render-markdown').set(state) end,
    })
    :map('<leader>um')
end)
