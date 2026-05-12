Plug({
  'MeanderingProgrammer/render-markdown.nvim',
  init = function()
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
  end,
  toggle = {
    ['yom'] = {
      name = 'Render Markdown',
      get = function() return require('render-markdown').get() end,
      set = function(state) return require('render-markdown').set(state) end,
    },
  },
})

return {
  ['2'] = require('nvim.ui.2'),
  icons = require('nvim.ui.icons'),
  status = require('nvim.ui.status'),
}
