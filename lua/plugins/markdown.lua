local M = { 'MeanderingProgrammer/render-markdown.nvim' }

M.enabled = false

M.event = 'BufWinEnter'

M.ft = { 'markdown', 'rmd', 'quarto', 'codecompanion' }

M.opts = {
  file_types = { 'markdown', 'rmd', 'quarto', 'codecompanion' },
  completions = { blink = { enabled = false } },
  bullet = { right_pad = 1 },
  -- checkbox = { enabled = false },
  code = {
    inline_pad = 1,
    border = 'thick',
    right_pad = 1,
    sign = false,
    width = 'block',
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
      local m = require('render-markdown')
      if enabled then
        m.enable()
      else
        m.disable()
      end
    end,
  }):map('<leader>um')
end

return M
