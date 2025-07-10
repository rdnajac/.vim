return {
  lualine_a = { { 'mode', separator = { right = '' } } },
  lualine_b = {
    {
      '%S',
      cond = function()
        local ok, res = pcall(vim.api.nvim_eval_statusline, '%S', {})
        return ok and res and res.str ~= ''
      end,
      separator = { right = '' },
    },
  },
  lualine_c = {
    { 'diff', symbols = LazyVim.config.icons.git },
    {
      function()
        local reg = vim.fn.reg_recording()
        return reg ~= '' and 'recording @' .. reg or ''
      end,
      color = { fg = '#ff3344', bg = 'NONE', gui = 'bold' },
    },
    Snacks.profiler.status(),
  },

  lualine_x = {},
  lualine_y = {},
  lualine_z = {
    {
      function()
        local highlighter = require('vim.treesitter.highlighter')
        local buf = vim.api.nvim_get_current_buf()
        if highlighter.active[buf] then
          return ' '
        end
        return ''
      end,
    },
    {
      function()
        for _, client in pairs(vim.lsp.get_clients({ bufnr = 0 })) do
          if client.name == 'GitHub Copilot' then
            return LazyVim.config.icons.kinds.Copilot
          end
        end
        return ''
      end,
    },
    {
      function()
        return ''
      end,
      padding = { left = 0, right = 0 },
      cond = function()
        local clients = vim.lsp.get_clients({ bufnr = 0 })
        return #clients > 0
      end,
    },
    { require('spec.lualine.components.lsp_status') },
  },
}
