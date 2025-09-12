local M = { 'MeanderingProgrammer/render-markdown.nvim' }

M.event = { 'BufWinEnter' }

---@type render.md.UserConfig
M.opts = {
  file_types = { 'markdown', 'rmd', 'quarto', 'codecompanion' },
  bullet = { right_pad = 1 },
  completions = { blink = { enabled = false } },
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

M.after = function()
  local m = require('render-markdown')
  m.set(true)
  Snacks.toggle({
    name = 'Render Markdown',
    get = function()
      return require('render-markdown.state').get()
    end,
    set = function(enabled)
      m.set(enabled)
    end,
  }):map('<leader>um')
end

return M
