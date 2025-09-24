M = {}

M.specs = {
  'github/copilot.vim',
}

M.config = function()
  vim.g.copilot_no_tab_map = true
  vim.keymap.set('i', '<C-J>', 'copilot#Accept("\\<CR>")', {
    expr = true,
    replace_keycodes = false,
  })
end

-- TODO: add copilot toggle
M.after = function()
  require('nvim.util.module').on_module('blink.cmp', function()
    local aug = vim.api.nvim_create_augroup('BlinkCopilot', {})

    vim.api.nvim_create_autocmd('User', {
      pattern = 'BlinkCmpMenuOpen',
      group = aug,
      command = 'call copilot#Dismiss() | let b:copilot_enabled = v:false',
    })

    vim.api.nvim_create_autocmd('User', {
      pattern = 'BlinkCmpMenuClose',
      group = aug,
      command = 'let b:copilot_enabled = v:true',
    })
  end)
end

M.status = function()
  -- TODO: util func in nv.lsp module
  for _, client in pairs(vim.lsp.get_clients()) do
    if client.name == 'copilot' then
      return nv.icons.src.copilot
    end
  end
  return ''
end

return M
