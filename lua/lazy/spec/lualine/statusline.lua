local ns = vim.api.nvim_create_namespace('lualine_showcmd_eval')

vim.on_key(function()
  local ok, res = pcall(vim.api.nvim_eval_statusline, '%S', {})
  if ok and res and res.str ~= '' then
    require('lualine').refresh()
  end
end, ns)
return {
  lualine_a = { { 'mode', separator = { right = '' } } },
  lualine_b = {
  { '%S',
      cond = function()
        local ok, res = pcall(vim.api.nvim_eval_statusline, '%S', {})
        return ok and res and res.str ~= ''
      end,
      separator = { right = '' },
  },
  },

  lualine_c = {
    {
      function()
        local reg = vim.fn.reg_recording()
        return reg ~= '' and 'recording @' .. reg or ''
      end,
      color = { fg = '#ff3344', bg = 'NONE', gui = 'bold' },
    },
    -- Snacks.profiler.status(),
    -- { '%=', color = 'Normal' }, -- balance and define center
  },

  lualine_x = {},
  lualine_y = {},
  lualine_z = {
    {
      function()
        for _, client in pairs(vim.lsp.get_clients({ bufnr = 0 })) do
          if client.name == 'GitHub Copilot' then
            return LazyVim.config.icons.kinds.Copilot
          end
        end
        return ''
      end,
      color = { fg = '#000000', gui = 'reverse,bold' },
    },
    { require('lazy.spec.lualine.lsp_status'), color = { fg = '#000000', gui = 'reverse,bold' } },
  },
}
