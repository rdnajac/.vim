if vim.fn.exists('g:loaded_copilot') == 0 then
  return
end

---@diagnostic disable-next-line: duplicate-set-field
vim.deprecate = function() end -- HACK: remove this once plugin is updated

Snacks.util.on_module('blink.cmp', function()
  local aug = vim.api.nvim_create_augroup('copilot', { clear = true })
  -- Block the normal Copilot suggestions if using blink integration
  -- vim.api.nvim_create_autocmd({ 'FileType', 'BufUnload' }, {
  --   group = 'github_copilot',
  --   callback = function(args)
  --     vim.fn['copilot#On' .. args.event]()
  --   end,
  -- })
  -- vim.fn['copilot#OnFileType']()

  ---@diagnostic disable-next-line: param-type-mismatch
  vim.api.nvim_create_autocmd('User', {
    pattern = 'BlinkCmpMenuOpen',
    group = aug,
    callback = function()
      vim.fn['copilot#Dismiss']()
      vim.b.copilot_suggestion_hidden = true
    end,
  })

  ---@diagnostic disable-next-line: param-type-mismatch
  vim.api.nvim_create_autocmd('User', {
    pattern = 'BlinkCmpMenuClose',
    group = aug,
    callback = function()
      vim.b.copilot_suggestion_hidden = false
    end,
  })
end)
