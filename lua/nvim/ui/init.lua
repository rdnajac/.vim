local M = {
  ['2'] =  require('nvim.ui.2'),
  icons = require('nvim.ui.icons'),
  status = require('nvim.ui.status'),
}

M.winbar = function()
  if vim.bo.filetype == 'snacks_dashboard' then
    return ''
  end
  if vim.api.nvim_get_current_win() ~= tonumber(vim.g.actual_curwin) then
    return M.status.buffer()
  end
  local a = M.status.buffer
  local b = M.status.lsp
  local c = M.status.treesitter
  return M.status.render(a(), b(), ' ' .. c()) .. '%#WinBar# '
end

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

return M
